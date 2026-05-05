'use client'

import { Home, User, Users } from 'lucide-react'
import { usePathname } from 'next/navigation'
import Link from 'next/link'
import { useAuthStore } from '@repo/api-client/store/auth-store'
import { AppType } from '@repo/common/constants/app-type'
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from '@repo/ui/sidebar'

export const navItems = [
  { title: '대시보드', url: '/', icon: Home },
  { title: '사용자 관리', url: '/users', icon: Users, requiredRole: AppType.AccountRoleType.SUPER_ADMIN },
  { title: '내 정보', url: '/profile', icon: User },
]

export function AppSidebar({ ...props }: React.ComponentProps<typeof Sidebar>) {
  const pathname = usePathname()
  const { tokenResponse } = useAuthStore()
  const roles = tokenResponse?.roles ?? []
  const visibleNavItems = navItems.filter(
    (item) => !item.requiredRole || roles.includes(item.requiredRole)
  )

  return (
    <Sidebar {...props}>
      <SidebarContent>
        <SidebarGroup>
          <SidebarGroupLabel>Admin</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu>
              {visibleNavItems.map((item) => {
                const isActive =
                  pathname === item.url ||
                  (item.url !== '/' && pathname.startsWith(item.url))

                return (
                  <SidebarMenuItem key={item.title}>
                    <SidebarMenuButton asChild isActive={isActive}>
                      <Link href={item.url}>
                        <item.icon />
                        <span>{item.title}</span>
                      </Link>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                )
              })}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>
    </Sidebar>
  )
}