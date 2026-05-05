'use client'

import { useRouter } from 'next/navigation'
import { toast } from 'sonner'
import { Button } from '@repo/ui/button'
import { useAuthStore } from '@repo/api-client/store/auth-store'
import { logout as logoutService } from '@repo/api-client/service/auth-service'

export function SiteHeader() {
  const router = useRouter()
  const { clearTokenResponse } = useAuthStore()

  const handleLogout = async () => {
    try {
      await logoutService()
    } finally {
      clearTokenResponse()
      toast.success('로그아웃되었습니다.')
      router.push('/login')
    }
  }

  return (
    <header className="sticky top-0 z-10 border-b bg-background/95 backdrop-blur">
      <div className="mx-auto flex h-14 w-full max-w-6xl items-center justify-between px-4">
        <button
          type="button"
          className="text-sm font-semibold tracking-tight"
          onClick={() => router.push('/')}
        >
          User
        </button>
        <div className="flex items-center gap-2">
          <Button variant="outline" onClick={() => router.push('/my/profile')}>
            내 정보
          </Button>
          <Button variant="outline" onClick={handleLogout}>
            로그아웃
          </Button>
        </div>
      </div>
    </header>
  )
}
