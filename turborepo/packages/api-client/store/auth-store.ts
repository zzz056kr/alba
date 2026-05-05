import { create } from 'zustand'
import { TokenDto } from '@repo/common/model/dto/token-dto'
import { refresh } from '@repo/api-client/service/auth-service'
import { isTokenExpired } from '@repo/common/utils/auth-utils'

type InitializationStatus = 'pending' | 'success' | 'error'

interface AuthState {
  tokenResponse: TokenDto.TokenResponse | null
  tokenIssuedAt: number | null
  initStatus: InitializationStatus
  setTokenResponse: (token: TokenDto.TokenResponse) => void
  clearTokenResponse: () => void
  isAuthenticated: () => boolean
  refreshToken: () => Promise<boolean>
  initializeAuth: () => Promise<void>
  isInitialized: () => boolean
}

export const useAuthStore = create<AuthState>()((set, get) => ({
  tokenResponse: null,
  tokenIssuedAt: null,
  initStatus: 'pending' as InitializationStatus,

  setTokenResponse: (token: TokenDto.TokenResponse) => set({
    tokenResponse: token,
    tokenIssuedAt: Date.now()
  }),

  clearTokenResponse: () => set({
    tokenResponse: null,
    tokenIssuedAt: null
  }),

  isAuthenticated: () => {
    const { tokenResponse, tokenIssuedAt } = get()
    return tokenResponse !== null && !isTokenExpired(tokenResponse, tokenIssuedAt)
  },

  refreshToken: async () => {
    try {
      const response = await refresh()
      if (response.data) {
        get().setTokenResponse(response.data)
        return true
      }
      return false
    } catch {
      get().clearTokenResponse()
      return false
    }
  },

  initializeAuth: async () => {
    if (get().isInitialized()) return

    try {
      const response = await refresh()
      if (response.data) {
        get().setTokenResponse(response.data)
        set({ initStatus: 'success' })
      } else {
        set({ initStatus: 'success' })
      }
    } catch {
      set({ initStatus: 'error' })
    }
  },

  isInitialized: () => {
    return get().initStatus !== 'pending'
  },
}))