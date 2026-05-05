'use client'

import { useSmartSheet } from '@repo/ui/smart-sheet'
import { useAccountList } from '@/src/hooks/useAccountQueries'
import { useUsersSearchParams } from './useUsersSearchParams'
import type { AccountDto } from '@repo/common/model/dto/account-dto'
import type { UsersPageReturn } from '@/src/model/client/users-types'
import AccountSheet from '@/src/component/sheet/AccountSheet'

export function useUsersActions(): UsersPageReturn {
  const { openSheet } = useSmartSheet()

  const {
    appliedFilters,
    filters,
    pagination,
    setKeyword,
    setRoles,
    setStatuses,
    setPage,
    applySearch,
    reset,
    isInitialized
  } = useUsersSearchParams()

  // API 쿼리 파라미터 생성
  const searchParams: AccountDto.SearchParams = {
    page: pagination.page,
    size: pagination.size,
    keyword: appliedFilters.keyword || undefined,
    roles: appliedFilters.roles.length > 0 ? appliedFilters.roles : undefined,
    statuses: appliedFilters.statuses.length > 0 ? appliedFilters.statuses : undefined
  }
  const { data, isLoading, error } = useAccountList(searchParams, isInitialized)

  const accounts = data?.list || []
  const totalCount = data?.total || 0
  const totalPages = data?.pages || 1

  const handleRowClick = (user: AccountDto.Summary) => {
    if (!user.id) return
    openSheet({
      id: `account-detail-${user.id}`,
      title: `계정 정보 - ${user.name ?? user.id}`,
      content: <AccountSheet accountId={user.id} />
    })
  }

  return {
    // State
    filters,
    currentPage: pagination.page,
    accounts,
    totalCount,
    totalPages,
    isLoading: !isInitialized || isLoading,
    error: error as Error | null,
    isInitialized,

    // Actions
    handleSearch: applySearch,
    handleReset: reset,
    handleRowClick,
    handlePageChange: setPage,
    handleFilterChange: {
      keyword: setKeyword,
      roles: setRoles,
      statuses: setStatuses
    }
  }
}