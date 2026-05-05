'use client'

import {
  Table,
  TableBody,
  TableHead,
  TableHeader,
  TableRow,
} from '@repo/ui/table'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@repo/ui/card'
import { Pagination } from '@repo/ui/pagination'
import { TooltipProvider } from '@repo/ui/tooltip'
import { LoadingState, ErrorState, EmptyState } from '@repo/ui/table-states'
import type { AccountDto } from '@repo/common/model/dto/account-dto'
import { UsersTableRow } from './UsersTableRow'

const COLUMNS_COUNT = 5

interface UsersTableProps {
  data: AccountDto.Summary[]
  totalCount: number
  totalPages: number
  currentPage: number
  isLoading: boolean
  error: Error | null
  onRowClick: (user: AccountDto.Summary) => void
  onPageChange: (page: number) => void
}

export function UsersTable({
  data,
  totalCount,
  totalPages,
  currentPage,
  isLoading,
  error,
  onRowClick,
  onPageChange
}: UsersTableProps) {
  const getDescription = () => {
    if (isLoading) return '검색 중...'
    return `총 ${totalCount}개의 사용자가 검색되었습니다`
  }

  return (
    <TooltipProvider>
      <Card className="mx-4 lg:mx-6">
        <CardHeader>
          <div className="space-y-1.5">
            <CardTitle>사용자 목록</CardTitle>
            <CardDescription>{getDescription()}</CardDescription>
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>이름</TableHead>
                <TableHead>권한</TableHead>
                <TableHead>상태</TableHead>
                <TableHead>마지막 로그인</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {isLoading ? (
                <LoadingState colSpan={COLUMNS_COUNT} />
              ) : error ? (
                <ErrorState colSpan={COLUMNS_COUNT} />
              ) : data.length === 0 ? (
                <EmptyState colSpan={COLUMNS_COUNT} />
              ) : (
                data.map((user) => (
                  <UsersTableRow
                    key={user.no || user.id}
                    user={user}
                    onClick={onRowClick}
                  />
                ))
              )}
            </TableBody>
          </Table>

          {!isLoading && totalPages > 1 && (
            <div className="mt-6">
              <Pagination
                page={currentPage}
                totalPages={totalPages}
                onChange={onPageChange}
              />
            </div>
          )}
        </CardContent>
      </Card>
    </TooltipProvider>
  )
}