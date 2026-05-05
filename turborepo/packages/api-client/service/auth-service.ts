import type { ResponseModel } from '@repo/common/model/response-model'
import type { AccountDto } from '@repo/common/model/dto/account-dto'
import type { TokenDto } from '@repo/common/model/dto/token-dto'
import { AuthApi as ServerAuthApi } from '../api/auth-api'
import { getDataSourceType } from '../core/runtime'
import { MockAuthApi } from '../mock/auth-mock'

function getAuthApi() {
  return getDataSourceType() === 'server' ? ServerAuthApi : MockAuthApi
}

export const join = (
  form: AccountDto.JoinForm
): Promise<ResponseModel<TokenDto.TokenResponse>> => {
  return getAuthApi().join(form).then((response) => response.data)
}

export const login = (
  form: AccountDto.LoginForm
): Promise<ResponseModel<TokenDto.TokenResponse>> => {
  return getAuthApi().login(form).then((response) => response.data)
}

export const refresh = (): Promise<ResponseModel<TokenDto.TokenResponse>> => {
  return getAuthApi().refresh().then((response) => response.data)
}

export const logout = (): Promise<ResponseModel<void>> => {
  return getAuthApi().logout().then((response) => response.data)
}
