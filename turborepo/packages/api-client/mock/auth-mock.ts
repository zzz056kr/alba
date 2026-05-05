import type { AccountDto } from '@repo/common/model/dto/account-dto'
import type { TokenDto } from '@repo/common/model/dto/token-dto'
import { AppType } from '@repo/common/constants/app-type'
import { mockResponse } from './mock-utils'

function createTokenResponse(id?: string): TokenDto.TokenResponse {
  return {
    accessToken: 'mock-access-token',
    accessTokenExpiresIn: 60 * 60,
    roles: [AppType.AccountRoleType.ADMIN],
    account: {
      id: id ?? 'admin',
    },
  }
}

export const MockAuthApi = {
  join: (_form: AccountDto.JoinForm) =>
    mockResponse<TokenDto.TokenResponse>(createTokenResponse()),

  login: (form: AccountDto.LoginForm) =>
    mockResponse<TokenDto.TokenResponse>(createTokenResponse(form.id)),

  refresh: () =>
    mockResponse<TokenDto.TokenResponse>(createTokenResponse()),

  logout: () =>
    mockResponse<void>(undefined),
}
