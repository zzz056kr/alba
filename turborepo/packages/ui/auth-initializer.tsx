'use client'

import { useEffect } from 'react'
import { useAuthStore } from '@repo/api-client/store/auth-store'

interface AuthInitializerProps {
  children: React.ReactNode
}

export default function AuthInitializer({ children }: AuthInitializerProps) {
  const initializeAuth = useAuthStore((state) => state.initializeAuth)

  useEffect(() => {
    initializeAuth()
  }, [initializeAuth])

  return <>{children}</>
}
