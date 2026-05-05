import { AxiosError, AxiosInstance, InternalAxiosRequestConfig, AxiosResponse } from 'axios'
import { TokenDto } from '@repo/common/model/dto/token-dto'
import { isTokenExpired, isTokenExpiringSoon } from '@repo/common/utils/auth-utils'
import { startLoading, stopLoading } from '@repo/common/utils/loading-bus'

export interface AuthState {
  tokenResponse: TokenDto.TokenResponse | null
  tokenIssuedAt: number | null
  refreshToken: () => Promise<boolean>
  clearTokenResponse: () => void
  isInitialized: () => boolean
  initializeAuth: () => Promise<void>
}

type RetryRequestConfig = InternalAxiosRequestConfig & {
  _retry?: boolean
  showErrorPopup?: boolean
}

type QueueEntry = {
  resolve: (value: string | null) => void
  reject: (error: unknown) => void
}

let isRefreshing = false
let failedQueue: QueueEntry[] = []

const processQueue = (error: unknown, token: string | null = null) => {
  failedQueue.forEach(({ resolve, reject }) => {
    if (error) {
      reject(error)
    } else {
      resolve(token)
    }
  })

  failedQueue = []
}

export const setupAxiosInterceptors = (
  axiosInstance: AxiosInstance,
  getAuthState: () => AuthState,
  showError: (message: string) => void,
  onRedirectToLogin: () => void,
  onForbidden: () => void = () => {},
) => {
  // Request Interceptor - 토큰 자동 첨부
  axiosInstance.interceptors.request.use(
    async (config: InternalAxiosRequestConfig) => {
      if (config.showLoading !== false) startLoading()

      const isPublicRequest = config.url?.includes('/auth/login') ||
                             config.url?.includes('/auth/register') ||
                             config.url?.includes('/auth/refresh')

      if (isPublicRequest) {
        return config
      }

      let { tokenResponse, refreshToken, clearTokenResponse } = getAuthState()
      const { isInitialized, initializeAuth } = getAuthState()

      if (!isInitialized()) {
        await initializeAuth()
        const updatedState = getAuthState()
        tokenResponse = updatedState.tokenResponse
        refreshToken = updatedState.refreshToken
        clearTokenResponse = updatedState.clearTokenResponse
      }

      if (tokenResponse?.accessToken) {
        const isLogoutRequest = config.url?.includes('/auth/logout')
        const { tokenIssuedAt } = getAuthState()

        if (!isLogoutRequest && isTokenExpired(tokenResponse, tokenIssuedAt)) {
          if (config.showLoading !== false) stopLoading()
          clearTokenResponse()
          onRedirectToLogin()
          return Promise.reject(new Error('Token expired'))
        }

        if (!isLogoutRequest && isTokenExpiringSoon(tokenResponse, tokenIssuedAt, 5)) {
          if (!isRefreshing) {
            isRefreshing = true

            try {
              const refreshSuccess = await refreshToken()
              if (refreshSuccess) {
                const newToken = getAuthState().tokenResponse?.accessToken
                processQueue(null, newToken)
                config.headers = config.headers || {}
                config.headers['Authorization'] = `Bearer ${newToken}`
              } else {
                processQueue(new Error('Token refresh failed'), null)
                if (config.showLoading !== false) stopLoading()
                clearTokenResponse()
                onRedirectToLogin()
                return Promise.reject(new Error('Token refresh failed'))
              }
            } catch (error) {
              processQueue(error, null)
              if (config.showLoading !== false) stopLoading()
              clearTokenResponse()
              onRedirectToLogin()
              return Promise.reject(error)
            } finally {
              isRefreshing = false
            }
          } else {
            return new Promise((resolve, reject) => {
              failedQueue.push({ resolve, reject })
            }).then((token) => {
              config.headers = config.headers || {}
              config.headers['Authorization'] = `Bearer ${token}`
              return config
            })
          }
        } else {
          config.headers = config.headers || {}
          config.headers['Authorization'] = `Bearer ${tokenResponse.accessToken}`
        }
      }

      return config
    },
    (error) => {
      return Promise.reject(error)
    }
  )

  // Response Interceptor - 에러 처리
  axiosInstance.interceptors.response.use(
    (response: AxiosResponse) => {
      if (response.config.showLoading !== false) stopLoading()
      return response
    },
    async (error: AxiosError<{ message?: string; error?: string }>) => {
      const originalRequest = error.config as RetryRequestConfig | undefined
      if (error.config?.showLoading !== false) stopLoading()

      if (!originalRequest) {
        const errorMessage = error.response?.data?.message ||
          error.response?.data?.error ||
          error.message ||
          '요청 처리 중 오류가 발생했습니다.'

        showError(errorMessage)
        return Promise.reject(error)
      }

      const isAuthRequest =
        originalRequest.url?.includes('/auth/logout') ||
        originalRequest.url?.includes('/auth/refresh')

      const errorMessage = error.response?.data?.message ||
        error.response?.data?.error ||
        error.message ||
        '요청 처리 중 오류가 발생했습니다.'

      const shouldHandle401Refresh =
        error.response?.status === 401 && !originalRequest._retry && !isAuthRequest

      if (originalRequest.showErrorPopup !== false && !isAuthRequest && !shouldHandle401Refresh) {
        showError(errorMessage)
      }

      if (error.response?.status === 403) {
        onForbidden()
      }

      if (shouldHandle401Refresh) {
        originalRequest._retry = true

        const { tokenResponse, refreshToken, clearTokenResponse } = getAuthState()

        if (tokenResponse && !isRefreshing) {
          isRefreshing = true

          try {
            const refreshSuccess = await refreshToken()

            if (refreshSuccess) {
              const newToken = getAuthState().tokenResponse?.accessToken
              processQueue(null, newToken)

              originalRequest.headers = originalRequest.headers || {}
              originalRequest.headers['Authorization'] = `Bearer ${newToken}`
              return axiosInstance(originalRequest)
            } else {
              processQueue(error, null)
              if (originalRequest.showErrorPopup !== false) {
                showError(errorMessage)
              }
              clearTokenResponse()
              onRedirectToLogin()
            }
          } catch (refreshError) {
            processQueue(refreshError, null)
            if (originalRequest.showErrorPopup !== false) {
              showError(errorMessage)
            }
            clearTokenResponse()
            onRedirectToLogin()
          } finally {
            isRefreshing = false
          }
        } else if (isRefreshing) {
          return new Promise((resolve, reject) => {
            failedQueue.push({ resolve, reject })
          }).then((token) => {
            originalRequest.headers = originalRequest.headers || {}
            originalRequest.headers['Authorization'] = `Bearer ${token}`
            return axiosInstance(originalRequest)
          }).catch((err) => {
            return Promise.reject(err)
          })
        } else {
          if (originalRequest.showErrorPopup !== false) {
            showError(errorMessage)
          }
          clearTokenResponse()
          onRedirectToLogin()
        }
      }

      return Promise.reject(error)
    }
  )
}
