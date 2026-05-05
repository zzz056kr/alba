import { TokenDto } from '../model/dto/token-dto'

export const isTokenExpired = (token: TokenDto.TokenResponse | null, issuedAt: number | null): boolean => {
  if (!token?.accessTokenExpiresIn || issuedAt === null) {
    return true
  }

  const now = Date.now()
  const expirationTime = issuedAt + (token.accessTokenExpiresIn * 1000)

  return now >= expirationTime
}

export const isTokenExpiringSoon = (token: TokenDto.TokenResponse | null, issuedAt: number | null, minutesBuffer = 5): boolean => {
  if (!token?.accessTokenExpiresIn || issuedAt === null) {
    return true
  }

  const now = Date.now()
  const expirationTime = issuedAt + (token.accessTokenExpiresIn * 1000)
  const bufferTime = minutesBuffer * 60 * 1000

  return now >= (expirationTime - bufferTime)
}

