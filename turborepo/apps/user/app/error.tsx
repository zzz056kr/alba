'use client'

import { useEffect } from 'react'
import { Button } from '@repo/ui/button'

interface ErrorProps {
  error: Error & { digest?: string }
  reset: () => void
}

export default function GlobalError({ error, reset }: ErrorProps) {
  useEffect(() => {
    console.error(error)
  }, [error])

  return (
    <div className="min-h-screen flex flex-col items-center justify-center gap-4">
      <h1 className="text-2xl font-bold text-foreground">오류가 발생했습니다</h1>
      <p className="text-muted-foreground text-sm">{error.message || '알 수 없는 오류가 발생했습니다.'}</p>
      <Button onClick={reset}>다시 시도</Button>
    </div>
  )
}