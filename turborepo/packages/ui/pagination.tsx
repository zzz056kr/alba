'use client'

import { ChevronRight, ChevronLeft } from 'lucide-react'
import { cn } from './lib/utils'
import { useRef, useState, useEffect, useLayoutEffect } from 'react'

const useIsomorphicLayoutEffect = typeof window !== 'undefined' ? useLayoutEffect : useEffect

interface PaginationProps {
  page: number       // 1-indexed
  totalPages: number
  onChange: (page: number) => void
}

const NAV_BUTTON_SIZE = 36  // < > 버튼은 고정 (아이콘)
const DIGIT_WIDTH = 9       // text-sm 기준 한 자리당 약 9px
const BUTTON_PADDING = 16   // px-2 양쪽 = 8px * 2
const MIN_BUTTON_SIZE = 36  // 최소 버튼 너비

function estimateButtonWidth(page: number): number {
  const digits = String(page).length
  return Math.max(MIN_BUTTON_SIZE, digits * DIGIT_WIDTH + BUTTON_PADDING)
}

function getPageWindow(page: number, totalPages: number, availableWidth: number): number[] {
  // 현재 페이지를 중심으로 양방향 확장
  const selected = new Set<number>([page])
  let usedWidth = estimateButtonWidth(page)
  let lo = page - 1
  let hi = page + 1

  while (lo >= 1 || hi <= totalPages) {
    let added = false

    if (hi <= totalPages) {
      const w = estimateButtonWidth(hi)
      if (usedWidth + w <= availableWidth) {
        selected.add(hi)
        usedWidth += w
        hi++
        added = true
      }
    }

    if (lo >= 1) {
      const w = estimateButtonWidth(lo)
      if (usedWidth + w <= availableWidth) {
        selected.add(lo)
        usedWidth += w
        lo--
        added = true
      }
    }

    if (!added) break
  }

  return Array.from(selected).sort((a, b) => a - b)
}

export function Pagination({ page, totalPages, onChange }: PaginationProps) {
  const containerRef = useRef<HTMLDivElement>(null)
  const [availableWidth, setAvailableWidth] = useState(360)

  useIsomorphicLayoutEffect(() => {
    const el = containerRef.current
    if (!el) return

    const update = () => {
      const totalWidth = el.offsetWidth
      const navWidth = (page > 1 ? NAV_BUTTON_SIZE : 0) + (page < totalPages ? NAV_BUTTON_SIZE : 0)
      setAvailableWidth(Math.max(0, totalWidth - navWidth))
    }

    update()
    const ro = new ResizeObserver(update)
    ro.observe(el)
    return () => ro.disconnect()
  }, [page, totalPages])

  if (totalPages <= 1) return null

  const pages = getPageWindow(page, totalPages, availableWidth)

  return (
    <nav ref={containerRef} className="w-full flex items-center justify-center" aria-label="페이지네이션">
      <div className="flex items-center rounded-md border divide-x">
        {page > 1 && (
          <button
            onClick={() => onChange(page - 1)}
            className="flex h-9 w-9 shrink-0 items-center justify-center text-sm hover:bg-accent transition-colors"
            aria-label="이전 페이지"
          >
            <ChevronLeft className="h-4 w-4" />
          </button>
        )}
        {pages.map((p) => (
          <button
            key={p}
            onClick={() => onChange(p)}
            aria-label={`${p}페이지`}
            aria-current={p === page ? 'page' : undefined}
            className={cn(
              'flex h-9 min-w-9 shrink-0 items-center justify-center px-2 text-sm transition-colors',
              p === page
                ? 'bg-primary text-primary-foreground'
                : 'hover:bg-accent'
            )}
          >
            {p}
          </button>
        ))}
        {page < totalPages && (
          <button
            onClick={() => onChange(page + 1)}
            className="flex h-9 w-9 shrink-0 items-center justify-center text-sm hover:bg-accent transition-colors"
            aria-label="다음 페이지"
          >
            <ChevronRight className="h-4 w-4" />
          </button>
        )}
      </div>
    </nav>
  )
}