'use client'

import { useState } from 'react'
import { Card, CardContent } from '@repo/ui/card'
import type { DashboardDto } from '@repo/common/model/dto/dashboard-dto'

const DAY_LABELS: Record<number, string> = { 0: '일', 1: '월', 2: '화', 3: '수', 4: '목', 5: '금', 6: '토' }

const STATUS_META: Record<string, { name: string; color: string }> = {
  ACTIVE:   { name: '활성', color: '#3B82F6' },
  INACTIVE: { name: '비활성', color: '#10B981' },
  PENDING:  { name: '대기', color: '#F59E0B' },
  DELETED:  { name: '탈퇴', color: '#EF4444' },
}

const chartTypes = [
  { id: 'pie', label: '파이차트' },
  { id: 'bar', label: '바차트' },
]

interface DashboardChartProps {
  stats: DashboardDto.Stats | null
}

export function DashboardChart({ stats }: DashboardChartProps) {
  const [selectedChart, setSelectedChart] = useState('pie')

  const weekTrend = stats?.weeklyTrend.map((d) => ({
    label: DAY_LABELS[new Date(d.date).getDay()] ?? d.date,
    value: d.count,
  })) ?? []

  const statusDist = (stats?.statusCounts ?? []).map((s) => ({
    name: STATUS_META[s.status]?.name ?? s.status,
    value: s.count,
    color: STATUS_META[s.status]?.color ?? '#6B7280',
  }))

  const maxTrend = weekTrend.length ? Math.max(...weekTrend.map((d) => d.value)) : 1
  const total = statusDist.reduce((sum, d) => sum + d.value, 0)

  return (
    <div className="grid gap-4 md:grid-cols-2 px-4 lg:px-6">
      {/* 일별 가입 추이 */}
      <Card>
        <CardContent className="pt-4">
          <h3 className="text-lg font-semibold mb-4">일별 가입 추이</h3>
          <p className="text-sm text-muted-foreground mb-4">최근 7일간 신규 가입 수</p>
          {weekTrend.length === 0 ? (
            <div className="flex items-center justify-center h-40 text-sm text-muted-foreground">데이터 없음</div>
          ) : (
            <div className="flex items-end gap-2 h-40">
              {weekTrend.map((d) => (
                <div key={d.label} className="flex flex-col items-center flex-1 gap-1">
                  <span className="text-xs text-muted-foreground">{d.value}</span>
                  <div
                    className="w-full rounded-t-sm bg-blue-500"
                    style={{ height: `${(d.value / maxTrend) * 100}%` }}
                  />
                  <span className="text-xs text-muted-foreground">{d.label}</span>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* 계정 상태 분포 */}
      <Card>
        <CardContent className="pt-4">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold">계정 상태 분포</h3>
            <div className="flex gap-2">
              {chartTypes.map((ct) => (
                <button
                  key={ct.id}
                  type="button"
                  onClick={() => setSelectedChart(ct.id)}
                  className={`inline-flex items-center justify-center rounded-full border px-3 py-1 text-xs font-medium cursor-pointer transition-all ${
                    selectedChart === ct.id
                      ? 'bg-blue-500 text-white border-blue-500'
                      : 'border-gray-300 bg-white hover:bg-gray-50 text-gray-700'
                  }`}
                >
                  {ct.label}
                </button>
              ))}
            </div>
          </div>

          {statusDist.length === 0 ? (
            <div className="flex items-center justify-center h-28 text-sm text-muted-foreground">데이터 없음</div>
          ) : selectedChart === 'pie' ? (
            <div className="flex items-center gap-6">
              <div
                className="shrink-0 rounded-full h-28 w-28"
                style={{
                  background: `conic-gradient(${statusDist.map((d, i) => {
                    const start = statusDist.slice(0, i).reduce((s, x) => s + x.value, 0)
                    const end = start + d.value
                    return `${d.color} ${((start / total) * 360).toFixed(1)}deg ${((end / total) * 360).toFixed(1)}deg`
                  }).join(', ')})`,
                }}
              />
              <div className="space-y-2 flex-1">
                {statusDist.map((d) => (
                  <div key={d.name} className="flex items-center justify-between text-sm">
                    <div className="flex items-center gap-2">
                      <span className="inline-block h-2.5 w-2.5 rounded-full" style={{ backgroundColor: d.color }} />
                      <span>{d.name}</span>
                    </div>
                    <span className="text-muted-foreground">
                      {d.value}명 ({((d.value / total) * 100).toFixed(1)}%)
                    </span>
                  </div>
                ))}
              </div>
            </div>
          ) : (
            <div className="space-y-3 mt-2">
              <p className="text-sm text-muted-foreground">총 {total}명</p>
              {statusDist.map((d) => {
                const pct = ((d.value / total) * 100).toFixed(1)
                return (
                  <div key={d.name} className="space-y-1">
                    <div className="flex justify-between text-sm">
                      <span className="font-medium">{d.name}</span>
                      <span className="text-muted-foreground">{d.value}명 ({pct}%)</span>
                    </div>
                    <div className="h-2 bg-muted rounded-full overflow-hidden">
                      <div
                        className="h-full rounded-full transition-all duration-300"
                        style={{ width: `${pct}%`, backgroundColor: d.color }}
                      />
                    </div>
                  </div>
                )
              })}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  )
}
