'use client'

import { useEffect, useState } from 'react'
import { getStats } from '@repo/api-client/service/dashboard-service'
import type { DashboardDto } from '@repo/common/model/dto/dashboard-dto'
import { DashboardStatCards } from './items/DashboardStatCards'
import { DashboardChart } from './items/DashboardChart'
import { DashboardRecentUsers } from './items/DashboardRecentUsers'
import ProtectedRoute from '@/src/component/ProtectedRoute'
import { AppType } from '@repo/common/constants/app-type'
import { useAuthStore } from '@repo/api-client/store/auth-store'

function DashboardContent() {
  const [stats, setStats] = useState<DashboardDto.Stats | null>(null)

  useEffect(() => {
    getStats().then((res) => {
      if (res.data) setStats(res.data)
    })
  }, [])

  return (
    <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
      <DashboardStatCards stats={stats} />
      <DashboardChart stats={stats} />
      <DashboardRecentUsers stats={stats} />
    </div>
  )
}

export default function DashboardPage() {
  const authState = useAuthStore()
  return (
    <ProtectedRoute
      authState={authState}
      requiredRoles={[AppType.AccountRoleType.ADMIN, AppType.AccountRoleType.SUPER_ADMIN]}
    >
      <DashboardContent />
    </ProtectedRoute>
  )
}
