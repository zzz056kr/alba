'use client';

import { useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { toast } from 'sonner'
import { AppType } from '@repo/common/constants/app-type'
import Spinner from '@repo/ui/spinner'

interface AuthState {
  tokenResponse: { roles?: string[] } | null
}

interface ProtectedRouteProps {
  children: React.ReactNode
  redirectTo?: string
  requiredRoles?: AppType.AccountRole[]
  fallback?: React.ReactNode
  authState: AuthState
}

export default function ProtectedRoute({
  children,
  redirectTo = '/unauthorized',
  requiredRoles,
  fallback = <Spinner />,
  authState,
}: ProtectedRouteProps) {
  const router = useRouter()
  const userRoles = authState.tokenResponse?.roles ?? []
  const isAuthorized =
    !requiredRoles ||
    requiredRoles.length === 0 ||
    requiredRoles.some((role) => userRoles.includes(role))

  useEffect(() => {
    if (!isAuthorized) {
      toast.error('접근 권한이 없습니다.')
      router.push(redirectTo)
    }
  }, [isAuthorized, redirectTo, router])

  if (!isAuthorized) {
    return <>{fallback}</>
  }

  return <>{children}</>
}

