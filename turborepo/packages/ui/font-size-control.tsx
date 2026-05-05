'use client'

import * as React from 'react'
import { Button } from './button'

const STORAGE_KEY = 'font-size'
const SIZES = [12, 14, 16, 18, 20]
const DEFAULT_SIZE = 16
const SIZE_LABELS: Record<number, string> = {
  12: '매우 작게',
  14: '작게',
  16: '보통',
  18: '크게',
  20: '매우 크게',
}

function applyFontSize(size: number) {
  document.documentElement.style.fontSize = `${size}px`
}

export function FontSizeControl() {
  const [mounted, setMounted] = React.useState(false)
  const [size, setSize] = React.useState(DEFAULT_SIZE)

  React.useEffect(() => {
    const saved = Number(localStorage.getItem(STORAGE_KEY)) || DEFAULT_SIZE
    setSize(saved)
    applyFontSize(saved)
    setMounted(true)
  }, [])

  const change = (next: number) => {
    setSize(next)
    localStorage.setItem(STORAGE_KEY, String(next))
    applyFontSize(next)
  }

  const decrease = () => {
    const idx = SIZES.indexOf(size)
    if (idx > 0) change(SIZES[idx - 1])
  }

  const increase = () => {
    const idx = SIZES.indexOf(size)
    if (idx < SIZES.length - 1) change(SIZES[idx + 1])
  }

  if (!mounted) {
    return (
      <div className="flex items-center">
        <Button variant="ghost" size="icon" disabled className="text-xs w-8 h-8">A-</Button>
        <Button variant="ghost" size="icon" disabled className="text-sm w-8 h-8">A+</Button>
      </div>
    )
  }

  return (
    <div className="flex items-center gap-2">
      <Button
        variant="ghost"
        size="icon"
        onClick={decrease}
        disabled={SIZES.indexOf(size) === 0}
        title="글자 크기 줄이기"
        className="text-xs w-8 h-8"
      >
        A-
      </Button>
      <span className="text-xs text-muted-foreground w-16 text-center">{SIZE_LABELS[size]}</span>
      <Button
        variant="ghost"
        size="icon"
        onClick={increase}
        disabled={SIZES.indexOf(size) === SIZES.length - 1}
        title="글자 크기 키우기"
        className="text-sm w-8 h-8"
      >
        A+
      </Button>
    </div>
  )
}