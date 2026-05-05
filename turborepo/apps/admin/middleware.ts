import { NextRequest, NextResponse } from 'next/server'
import { isMockDataSource } from '@repo/api-client/core/runtime'
import { REFRESH_TOKEN_COOKIE } from '@repo/common/constants/constants'

const PUBLIC_PATHS = ['/login', '/unauthorized']

// mock 모드에서는 실제 쿠키가 발급되지 않으므로 미들웨어 인증 체크를 건너뜀
const IS_MOCK = isMockDataSource()

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl

  // 공개 경로는 그냥 통과
  if (PUBLIC_PATHS.some((path) => pathname.startsWith(path))) {
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
    /*
     * 아래 경로는 매칭에서 제외:
     * - _next/static (정적 파일)
     * - _next/image (이미지 최적화)
     * - favicon.ico, 공개 assets
     */
    '/((?!_next/static|_next/image|favicon.ico|.*\\.svg$).*)',
  ],
}
