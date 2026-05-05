'use client'

import { useEffect } from 'react'
import { Button } from '@repo/ui/button'

interface ErrorProps {
  error: Error & { digest?: string }
  reset: () => void
}

export default function ProtectedError({ error, reset }: ErrorProps) {
  useEffect(() => {
    console.error(error)
  }, [error])

  return (
    <div className="flex flex-col items-center justify-center h-full min-h-[400px] gap-4 p-6">
      <h2 className="text-xl font-semibold text-foreground">페이지를 불러오는 중 오류가 발생했습니다</h2>
      <p className="text-muted-foreground text-sm">{error.message || '잠시 후 다시 시도해주세요.'}</p>
      <Button variant="outline" onClick={reset}>다시 시도</Button>
    </div>
  )
}