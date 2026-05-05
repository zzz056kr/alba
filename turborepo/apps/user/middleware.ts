import { NextRequest, NextResponse } from 'next/server'
import { isMockDataSource } from '@repo/api-client/core/runtime'
import { REFRESH_TOKEN_COOKIE } from '@repo/common/constants/constants'

// 로그인 필요한 경로 prefix. 하위 경로 모두 보호됨.
// 새 보호 영역 추가 시 이 배열에 prefix 만 추가하면 됨. (예: '/admin', '/settings')
const PROTECTED_PREFIXES: readonly string[] = ['/my']

// exact-match 로 보호할 경로 (prefix 가 아닌 것들).
// 홈 `/` 는 `app/(protected)/page.tsx` 라 로그인 전용 — prefix 로 쓰면 모든 URL 이 걸리므로 exact 로 분리.
const PROTECTED_EXACT: readonly string[] = ['/']

// mock 모드에서는 실제 쿠키가 발급되지 않으므로 미들웨어 인증 체크를 건너뜀
const IS_MOCK = isMockDataSource()

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl

  // 보호 경로가 아니면 그냥 통과 (로그인·탐색 등 전부 공개)
  const isProtected =
    PROTECTED_EXACT.includes(pathname) ||
    PROTECTED_PREFIXES.some(
      (prefix) => pathname === prefix || pathname.startsWith(`${prefix}/`),
    )
  if (!isProtected) {
    return NextResponse.next()
  }

  // mock 모드: 쿠키 체크 없이 통과 (인증은 클라이언트 AuthProvider가 담당)
  if (IS_MOCK) {
    return NextResponse.next()
  }

  // refresh token 쿠키가 없으면 로그인 페이지로 redirect
  const hasRefreshToken = request.cookies.has(REFRESH_TOKEN_COOKIE)
  if (!hasRefreshToken) {
    const loginUrl = new URL('/login', request.url)
    return NextResponse.redirect(loginUrl)
  }

  return NextResponse.next()
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.svg$).*)',
  ],
}