'use client'

import { Sun, Moon } from 'lucide-react'
import { useTheme } from './hooks/use-theme'
import { Button } from './button'

export function ThemeToggle() {
  const { theme, toggleTheme, mounted } = useTheme()

  if (!mounted) {
    return <Button variant="ghost" size="icon" disabled><Sun className="h-4 w-4" /></Button>
  }

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={toggleTheme}
      title={theme === 'dark' ? '다크 모드 (라이트로 변경)' : '라이트 모드 (다크로 변경)'}
    >
      {theme === 'dark' ? <Sun className="h-4 w-4" /> : <Moon className="h-4 w-4" />}
    </Button>
  )
}