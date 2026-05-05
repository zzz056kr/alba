'use client'

import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useAuthStore } from '@repo/api-client/store/auth-store'
import { logout } from '@repo/api-client/service/auth-service'

export default function Unauthorized() {
  const router = useRouter()
  const { isAuthenticated, clearTokenResponse } = useAuthStore()
  const authenticated = isAuthenticated()

  const handleLogout = async () => {
    try {
      await logout()
    } finally {
      clearTokenResponse()
      router.push('/login')
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-background py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div className="text-center">
          <h1 className="text-6xl font-bold text-destructive mb-4">403</h1>
          <h2 className="text-2xl font-bold text-foreground mb-2">
            접근 권한이 없습니다
          </h2>
          <p className="text-muted-foreground mb-6">
            이 페이지에 접근할 수 있는 권한이 없습니다.
          </p>
          <div className="flex flex-col items-center gap-3">
            <Link
              href="/"
              className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md bg-primary text-primary-foreground hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary"
            >
              홈으로 돌아가기
            </Link>
            {authenticated ? (
              <button
                onClick={handleLogout}
                className="inline-flex items-center px-4 py-2 border border-border text-sm font-medium rounded-md bg-background text-foreground hover:bg-muted focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary"
              >
                로그아웃
              </button>
            ) : (
              <Link
                href="/login"
                className="inline-flex items-center px-4 py-2 border border-border text-sm font-medium rounded-md bg-background text-foreground hover:bg-muted focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary"
              >
                로그인 페이지로 이동
              </Link>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}