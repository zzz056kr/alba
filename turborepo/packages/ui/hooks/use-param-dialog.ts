'use client'

import { useCallback, useMemo } from 'react'
import { useRouter, useSearchParams, usePathname } from 'next/navigation'

export interface UseParamDialogOptions {
  paramKey: string
}

export interface UseParamDialogReturn {
  isOpen: boolean
  value: string | null
  open: (value: string | number) => void
  close: () => void
}

/**
 * URL searchParams와 동기화되는 Dialog 상태 훅
 *
 * @example
 * // 1. 훅 사용
 * const dialog = useParamDialog({ paramKey: 'studentNo' })
 *
 * // 2. Dialog는 항상 렌더 (조건부 마운트 X → 깜빡임 방지)
 * <Dialog open={dialog.isOpen} onOpenChange={(o) => { if (!o) dialog.close() }}>
 *
 * // 3. 데이터 훅에 enabled 전달 (닫힌 상태에서 fetch 방지)
 * useMyDataQuery(id, { enabled: dialog.isOpen })
 *
 * // 4. hover prefetch (첫 오픈 시 로딩 깜빡임 방지)
 * onMouseEnter={() => queryClient.prefetchQuery(...)}
 */
export function useParamDialog({ paramKey }: UseParamDialogOptions): UseParamDialogReturn {
  const router = useRouter()
  const searchParams = useSearchParams()
  const pathname = usePathname()

  const value = searchParams.get(paramKey)
  const isOpen = value !== null

  const open = useCallback((newValue: string | number) => {
    const params = new URLSearchParams(searchParams.toString())
    params.set(paramKey, String(newValue))
    router.push(`${pathname}?${params.toString()}`, { scroll: false })
  }, [router, searchParams, pathname, paramKey])

  const close = useCallback(() => {
    const params = new URLSearchParams(searchParams.toString())
    params.delete(paramKey)
    const queryString = params.toString()
    router.push(queryString ? `${pathname}?${queryString}` : pathname, { scroll: false })
  }, [router, searchParams, pathname, paramKey])

  return useMemo(() => ({
    isOpen,
    value,
    open,
    close,
  }), [isOpen, value, open, close])
}