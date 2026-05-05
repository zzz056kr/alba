import type { ResponseModel } from '@repo/common/model/response-model'
import { EmailApi } from '../../api/email/email-api'

export const sendAuthCode = (
  email: string,
  type: string
): Promise<ResponseModel<void>> => {
  return EmailApi.sendAuthCode(email, type).then((response) => response.data)
}

export const verify = (
  email: string,
  code: string,
  type: string
): Promise<ResponseModel<void>> => {
  return EmailApi.verify(email, code, type).then((response) => response.data)
}
