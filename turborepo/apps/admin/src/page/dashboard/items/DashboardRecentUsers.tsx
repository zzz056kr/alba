'use client'

import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@repo/ui/card'
import { Badge } from '@repo/ui/badge'
import { Button } from '@repo/ui/button'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@repo/ui/table'
import { useRouter } from 'next/navigation'
import type { DashboardDto } from '@repo/common/model/dto/dashboard-dto'

interface DashboardRecentUsersProps {
  stats: DashboardDto.Stats | null
}

const roleVariant = (roles?: string[]) =>
  roles?.includes('ADMIN') || roles?.includes('SUPER_ADMIN') ? 'default' : 'secondary'

const statusVariant = (status?: string) =>
  status === 'ACTIVE' ? 'default' : 'outline'

const statusLabel = (status?: string) => {
  switch (status) {
    case 'ACTIVE': return '활성'
    case 'INACTIVE': return '비활성'
    case 'PENDING': return '대기'
    case 'DELETED': return '탈퇴'
    default: return status ?? '-'
  }
}

export function DashboardRecentUsers({ stats }: DashboardRecentUsersProps) {
  const router = useRouter()
  const recentAccounts = stats?.recentAccounts ?? []

  return (
    <Card className="mx-4 lg:mx-6">
      <CardHeader className="flex flex-row items-center justify-between">
        <div>
          <CardTitle>최근 가입 사용자</CardTitle>
          <CardDescription>최근 등록된 사용자 정보를 확인할 수 있습니다</CardDescription>
        </div>
        <Button variant="outline" size="sm" onClick={() => router.push('/users')}>
          더보기
        </Button>
      </CardHeader>
      <CardContent>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>아이디</TableHead>
              <TableHead>이름</TableHead>
              <TableHead>이메일</TableHead>
              <TableHead>권한</TableHead>
              <TableHead>상태</TableHead>
              <TableHead>가입일</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {recentAccounts.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center text-sm text-muted-foreground py-6">
                  데이터 없음
                </TableCell>
              </TableRow>
            ) : (
              recentAccounts.map((user) => (
                <TableRow
                  key={user.no}
                  className="cursor-pointer hover:bg-muted/50"
                  onClick={() => router.push('/users')}
                >
                  <TableCell className="font-medium">{user.id}</TableCell>
                  <TableCell>{user.name ?? '-'}</TableCell>
                  <TableCell className="text-muted-foreground">{user.email ?? '-'}</TableCell>
                  <TableCell>
                    <Badge variant={roleVariant(user.roles)}>
                      {user.roles?.[0] ?? '-'}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <Badge variant={statusVariant(user.status)}>
                      {statusLabel(user.status)}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {user.createdAt ? new Date(user.createdAt).toLocaleDateString('ko-KR') : '-'}
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  )
}
