'use client'

import { LogOut, Settings, User } from 'lucide-react'
import { useRouter, usePathname } from 'next/navigation'
import { toast } from 'sonner'
import { Button } from '@repo/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@repo/ui/dropdown-menu'
import { SidebarTrigger } from '@repo/ui/sidebar'
import { ThemeToggle } from '@repo/ui/theme-toggle'
import { SettingsPopover } from '@/src/component/SettingsPopover'
import { useAuthStore } from '@repo/api-client/store/auth-store'
import { logout as logoutService } from '@repo/api-client/service/auth-service'
import { navItems } from '@/src/component/AppSidebar'

export function SiteHeader() {
  const { tokenResponse, clearTokenResponse } = useAuthStore()
  const router = useRouter()
  const pathname = usePathname()

  const currentMenu =
    navItems.find(
      (item) =>
        pathname === item.url ||
        (item.url !== '/' && pathname.startsWith(item.url))
    ) || navItems[0]

  const handleLogout = async () => {
    try {
      await logoutService()
    } finally {
      clearTokenResponse()
      toast.success('로그아웃되었습니다.')
      router.push('/login')
    }
  }

  return (
    <header className="flex h-12 shrink-0 items-center gap-2 border-b px-4">
      <SidebarTrigger className="-ml-1" />
      {currentMenu && (
        <div className="flex items-center gap-2">
          <currentMenu.icon className="h-4 w-4" />
          <span className="text-sm font-medium">{currentMenu.title}</span>
        </div>
      )}
      <div className="flex flex-1 items-center">
        <div className="ml-auto flex items-center gap-2">
          <SettingsPopover />
          <ThemeToggle />
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon">
                <User className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-48">
              <DropdownMenuItem disabled>
                <User className="mr-2 h-4 w-4" />
                {tokenResponse?.account?.id ?? '사용자'}
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem onClick={() => router.push('/profile')}>
                <Settings className="mr-2 h-4 w-4" />
                내 정보
              </DropdownMenuItem>
              <DropdownMenuItem onClick={handleLogout}>
                <LogOut className="mr-2 h-4 w-4" />
                로그아웃
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
    </header>
  )
}