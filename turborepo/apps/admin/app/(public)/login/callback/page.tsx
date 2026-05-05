'use client';

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuthStore } from '@repo/api-client/store/auth-store';

export default function LoginCallbackPage() {
  const router = useRouter()
  const { refreshToken } = useAuthStore()

  useEffect(() => {
    refreshToken().then((success) => {
      if (success) {
        router.push('/')
      } else {
        router.push('/login')
      }
    })
  }, [refreshToken, router])

  return (
    <div className="min-h-screen flex items-center justify-center bg-background" role="status" aria-label="로딩 중">
      <div className="flex flex-col items-center space-y-4">
        <div className="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin" />
        <p className="text-sm text-muted-foreground">로그인 처리 중...</p>
      </div>
    </div>
  )
}
