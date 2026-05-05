'use client'

import { Card, CardContent, CardHeader, CardTitle } from '@repo/ui/card'
import { Users, Activity } from 'lucide-react'
import type { DashboardDto } from '@repo/common/model/dto/dashboard-dto'

interface DashboardStatCardsProps {
  stats: DashboardDto.Stats | null
}

export function DashboardStatCards({ stats }: DashboardStatCardsProps) {
  const todayStr = new Date().toISOString().slice(0, 10)
  const todayCount = stats?.weeklyTrend.find((d) => d.date === todayStr)?.count ?? 0
  const activeRatio = stats
    ? ((stats.activeAccounts / stats.totalAccounts) * 100).toFixed(1)
    : null

  const cards = [
    {
      title: '전체 사용자',
      value: stats?.totalAccounts.toLocaleString() ?? '-',
      description: '등록된 계정 수',
      sub: stats ? `오늘 ${todayCount}명 가입` : '',
      subColor: 'text-blue-600',
      icon: Users,
    },
    {
      title: '활성 계정',
      value: stats?.activeAccounts.toLocaleString() ?? '-',
      description: '활성 상태',
      sub: activeRatio ? `전체의 ${activeRatio}%` : '',
      subColor: 'text-green-600',
      icon: Activity,
    },
  ]

  return (
    <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3 px-4 lg:px-6">
      {cards.map((card, index) => (
        <Card key={index}>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">{card.title}</CardTitle>
            <card.icon className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{card.value}</div>
            <p className="text-xs text-muted-foreground">{card.description}</p>
            <p className={`text-xs mt-1 ${card.subColor}`}>{card.sub}</p>
          </CardContent>
        </Card>
      ))}
    </div>
  )
}
