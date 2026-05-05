'use client'

import { SmartSheetProvider } from '@repo/ui/smart-sheet'
import { useAuthStore } from '@repo/api-client/store/auth-store'
import { AppType } from '@repo/common/constants/app-type'
import ProtectedRoute from '@/src/component/ProtectedRoute'
import { useUsersActions } from './useUsersActions'
import { UsersSearchFilters } from './items/UsersSearchFilters'
import { UsersTable } from './items/UsersTable'

function UsersPageContent() {
  const {
    filters,
    currentPage,
    accounts,
    totalCount,
    totalPages,
    isLoading,
    error,
    handleSearch,
    handleReset,
    handleRowClick,
    handlePageChange,
    handleFilterChange
  } = useUsersActions()

  return (
    <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
      <UsersSearchFilters
        filters={filters}
        isLoading={isLoading}
        onSearch={handleSearch}
        onReset={handleReset}
        onFilterChange={handleFilterChange}
      />

      <UsersTable
        data={accounts}
        totalCount={totalCount}
        totalPages={totalPages}
        currentPage={currentPage}
        isLoading={isLoading}
        error={error}
        onRowClick={handleRowClick}
        onPageChange={handlePageChange}
      />
    </div>
  )
}

export default function UsersPage() {
  const { tokenResponse } = useAuthStore()
  return (
    <ProtectedRoute
      requiredRoles={[AppType.AccountRoleType.SUPER_ADMIN]}
      authState={{ tokenResponse }}
    >
      <SmartSheetProvider>
        <UsersPageContent />
      </SmartSheetProvider>
    </ProtectedRoute>
  )
}