'use client'

import { TableCell, TableRow } from '@repo/ui/table'
import { Badge } from '@repo/ui/badge'
import { Tooltip, TooltipContent, TooltipTrigger } from '@repo/ui/tooltip'
import { AppType } from '@repo/common/constants/app-type'
import { toBadgeVariant } from '@repo/ui/badge-utils'
import type { AccountDto } from '@repo/common/model/dto/account-dto'

interface UsersTableRowProps {
  user: AccountDto.Summary
  onClick: (user: AccountDto.Summary) => void
}

function formatRelativeTime(dateStr: string): string {
  const date = new Date(dateStr)
  const now = new Date()
  const diffMs = now.getTime() - date.getTime()
  const diffMinutes = Math.floor(diffMs / (1000 * 60))
  const diffHours = Math.floor(diffMs / (1000 * 60 * 60))
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24))

  if (diffMinutes < 1) return '방금 전'
  if (diffMinutes < 60) return `${diffMinutes}분 전`
  if (diffHours < 24) return `${diffHours}시간 전`
  if (diffDays < 7) return `${diffDays}일 전`
  return date.toLocaleDateString('ko-KR')
}

function formatKoreanDateTime(dateStr: string): string {
  return new Date(dateStr).toLocaleString('ko-KR', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

export function UsersTableRow({ user, onClick }: UsersTableRowProps) {
  const statusInfo = user.status ? AppType.AccountStatusInfo[user.status] : null

  return (
    <TableRow
      className="cursor-pointer hover:bg-muted/50 transition-colors"
      onClick={() => onClick(user)}
      tabIndex={0}
      role="button"
      aria-label={`${user.name ?? user.id} 상세 보기`}
      onKeyDown={(e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); onClick(user) } }}
    >
      <TableCell className="font-medium">{user.id}</TableCell>
      <TableCell>{user.name}</TableCell>
      <TableCell>
        <div className="flex gap-1 flex-wrap">
          {user.roles?.map((role: AppType.AccountRole) => (
            <Badge key={role} variant="outline" className="text-xs">
              {AppType.AccountRoleInfo[role]?.name || role}
            </Badge>
          ))}
        </div>
      </TableCell>
      <TableCell>
        {statusInfo ? (
          <Badge variant={toBadgeVariant(statusInfo.variant)}>
            {statusInfo.name}
          </Badge>
        ) : (
          <span className="text-muted-foreground">-</span>
        )}
      </TableCell>
      <TableCell>
        {user.lastLoginAt ? (
          <Tooltip>
            <TooltipTrigger className="cursor-help">
              {formatRelativeTime(user.lastLoginAt)}
            </TooltipTrigger>
            <TooltipContent>
              <p>{formatKoreanDateTime(user.lastLoginAt)}</p>
            </TooltipContent>
          </Tooltip>
        ) : (
          <span className="text-muted-foreground">-</span>
        )}
      </TableCell>
    </TableRow>
  )
}