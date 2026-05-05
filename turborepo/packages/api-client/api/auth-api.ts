import type { ResponseModel } from '@repo/common/model/response-model'
import type { AccountDto } from '@repo/common/model/dto/account-dto'
import type { TokenDto } from '@repo/common/model/dto/token-dto'
import { http } from '../core/http'

const BASE_URL = '/auth'

export const AuthApi = {
  join: (form: AccountDto.JoinForm) =>
    http.post<ResponseModel<TokenDto.TokenResponse>>(`/account/join`, form),

  login: (form: AccountDto.LoginForm) =>
    http.post<ResponseModel<TokenDto.TokenResponse>>(`${BASE_URL}/login`, form),

  refresh: () =>
    http.post<ResponseModel<TokenDto.TokenResponse>>(`${BASE_URL}/refresh`),

  logout: () =>
    http.post<ResponseModel<void>>(`${BASE_URL}/logout`),
}
