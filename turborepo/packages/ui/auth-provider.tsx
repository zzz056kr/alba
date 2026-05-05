'use client';

import { useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { useAuthStore } from '@repo/api-client/store/auth-store'
import { isTokenExpired } from '@repo/common/utils/auth-utils'
import { AppType } from '@repo/common/constants/app-type'
import Spinner from './spinner'

interface AuthProviderProps {
  children: React.ReactNode
}

export default function AuthProvider({ children }: AuthProviderProps) {
  const router = useRouter()
  const initializeAuth = useAuthStore((state) => state.initializeAuth)
  const initStatus = useAuthStore((state) => state.initStatus)
  const tokenResponse = useAuthStore((state) => state.tokenResponse)
  const tokenIssuedAt = useAuthStore((state) => state.tokenIssuedAt)

  const initialized = initStatus !== 'pending'
  const authenticated = tokenResponse !== null && !isTokenExpired(tokenResponse, tokenIssuedAt)
  const isGuest = authenticated &&
    tokenResponse?.roles?.length === 1 &&
    tokenResponse.roles[0] === AppType.AccountRoleType.GUEST

  useEffect(() => {
    initializeAuth()
  }, [initializeAuth])

  useEffect(() => {
    const handleAuthRedirect = () => {
      router.replace('/login')
    }
    const handleForbidden = () => {
      router.replace('/unauthorized')
    }

    window.addEventListener('auth:redirect-to-login', handleAuthRedirect)
    window.addEventListener('auth:redirect-to-unauthorized', handleForbidden)

    return () => {
      window.removeEventListener('auth:redirect-to-login', handleAuthRedirect)
      window.removeEventListener('auth:redirect-to-unauthorized', handleForbidden)
    }
  }, [router])

  useEffect(() => {
    if (initialized && !authenticated) {
      router.replace('/login')
    }
  }, [authenticated, initialized, router])

  useEffect(() => {
    if (initialized && authenticated && isGuest) {
      const email = tokenResponse?.account?.email
      const target = email
        ? `/email-verify?email=${encodeURIComponent(email)}`
        : '/email-verify'
      router.replace(target)
    }
  }, [initialized, authenticated, isGuest, tokenResponse, router])

  if (!initialized) {
    return <Spinner />
  }

  if (!authenticated || isGuest) {
    return <Spinner />
  }

  return <>{children}</>
}