'use client'

import { Card, CardContent, CardHeader, CardTitle } from '@repo/ui/card'
import { Label } from '@repo/ui/label'
import { Input } from '@repo/ui/input'
import { Badge } from '@repo/ui/badge'
import { Button } from '@repo/ui/button'
import { MultiSelect } from '@repo/ui/multi-select'
import { Loader2, RotateCcw, Search } from 'lucide-react'
import { AppType } from '@repo/common/constants/app-type'
import { cn } from '@repo/ui/lib/utils'
import { useSmartSheet } from '@repo/ui/smart-sheet'
import AccountSheet from '@/src/component/sheet/AccountSheet'
import type { UsersFilterActions, UsersFilters } from '@/src/model/client/users-types'

interface UsersSearchFiltersProps {
  filters: UsersFilters
  isLoading: boolean
  onSearch: () => void
  onReset: () => void
  onFilterChange: UsersFilterActions
}

const ROLE_OPTIONS = Object.entries(AppType.AccountRoleInfo).map(([value, info]) => ({
  value,
  label: (info as { name: string }).name,
}))
const STATUS_OPTIONS = Object.entries(AppType.AccountStatusInfo) as [AppType.AccountStatus, { name: string; variant: string }][]

export function UsersSearchFilters({
  filters,
  isLoading,
  onSearch,
  onReset,
  onFilterChange
}: UsersSearchFiltersProps) {
  const { openSheet } = useSmartSheet()

  function toggleStatus(status: AppType.AccountStatus) {
    const next = filters.statuses.includes(status)
      ? filters.statuses.filter(s => s !== status)
      : [...filters.statuses, status]
    onFilterChange.statuses(next)
  }

  return (
    <Card className="mx-4 lg:mx-6">
      <CardHeader className="flex flex-row items-center justify-between">
        <CardTitle>검색 조건</CardTitle>
        <Button
          size="sm"
          onClick={() =>
            openSheet({
              id: "account-create",
              title: "계정 등록",
              content: <AccountSheet />,
            })
          }
        >
          + 계정 등록
        </Button>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 items-end">
          {/* 권한 필터 */}
          <div>
            <Label className="text-sm font-medium mb-2 block">권한</Label>
            <MultiSelect
              options={ROLE_OPTIONS}
              selected={filters.roles as string[]}
              onChange={(v) => onFilterChange.roles(v as AppType.AccountRole[])}
              placeholder="전체"
            />
          </div>

          {/* 상태 필터 */}
          <div>
            <Label className="text-sm font-medium mb-2 block">상태</Label>
            <div className="flex flex-wrap gap-1.5">
              {STATUS_OPTIONS.map(([status, info]) => (
                <Badge
                  key={status}
                  role="checkbox"
                  aria-checked={filters.statuses.includes(status)}
                  tabIndex={0}
                  variant={filters.statuses.includes(status) ? 'default' : 'outline'}
                  className={cn('cursor-pointer select-none')}
                  onClick={() => toggleStatus(status)}
                  onKeyDown={(e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggleStatus(status) } }}
                >
                  {info.name}
                </Badge>
              ))}
            </div>
          </div>

          {/* 검색어 입력 */}
          <div>
            <Label htmlFor="keyword" className="text-sm font-medium mb-2 block">검색</Label>
            <div className="flex items-center gap-2">
              <Input
                id="keyword"
                placeholder="ID 또는 이름"
                value={filters.keyword}
                onChange={(e) => onFilterChange.keyword(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') {
                    onSearch()
                  }
                }}
                className="flex-1 h-10"
              />
              <Button onClick={onSearch} size="sm" disabled={isLoading} aria-label="검색">
                {isLoading ? <Loader2 className="h-4 w-4 animate-spin" /> : <Search className="h-4 w-4" />}
              </Button>
              <Button variant="outline" onClick={onReset} size="sm" aria-label="초기화">
                <RotateCcw className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  )
}
