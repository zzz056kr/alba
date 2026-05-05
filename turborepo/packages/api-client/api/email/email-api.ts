import type { ResponseModel } from '@repo/common/model/response-model'
import { http } from '../../core/http'

const BASE_URL = '/email'

export const EmailApi = {
  sendAuthCode: (email: string, type: string) =>
    http.post<ResponseModel<void>>(`${BASE_URL}/send-auth-code`, { email, type }),

  verify: (email: string, code: string, type: string) =>
    http.post<ResponseModel<void>>(`${BASE_URL}/verify`, { email, code, type }),
}
