import { http } from "@repo/api-client/core/http"
import { setupAxiosInterceptors } from "@repo/api-client/interceptors"
import { useAuthStore } from '@repo/api-client/store/auth-store'
import { toast } from 'sonner'

export const appAxios = http

appAxios.defaults.baseURL = process.env.NEXT_PUBLIC_API_BASE_URL

// 서버에서 응답한 메시지가 에러인경우 팝업으로 띄우기
appAxios.defaults.showErrorPopup = true
// api 요청 로딩창 띄우기
appAxios.defaults.showLoading = true

// 인터셉터 설정
setupAxiosInterceptors(
  appAxios,
  () => useAuthStore.getState(),
  (message) => toast.error(message),
  () => window.dispatchEvent(new CustomEvent('auth:redirect-to-login')),
  () => window.dispatchEvent(new CustomEvent('auth:redirect-to-unauthorized')),
)
