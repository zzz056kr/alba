import { DEFAULT_PAGE, DEFAULT_PAGE_SIZE } from '@repo/common/constants/constants'
import { useUrlSearchParams } from '@repo/ui/hooks/use-url-search-params'
import type { AccountDto } from '@repo/common/model/dto/account-dto'
import { AppType } from '@repo/common/constants/app-type'
import type { UsersFilters, PaginationInfo } from '@/src/model/client/users-types'
import { createSerializer, createDeserializer } from '@repo/common/utils/search-utils'

const defaultValues: AccountDto.SearchParams = {
  keyword: '',
  roles: [],
  statuses: [],
  page: DEFAULT_PAGE,
  size: DEFAULT_PAGE_SIZE
}

const serialize = createSerializer<AccountDto.SearchParams>(['size'])
const deserialize = createDeserializer<AccountDto.SearchParams>(
  defaultValues,
  ['roles', 'statuses']
)

export function useUsersSearchParams() {
  const {
    appliedValues,
    tempValues,
    updateTempValues,
    updateAppliedValues,
    applySearch: originalApplySearch,
    reset,
    isInitialized
  } = useUrlSearchParams<AccountDto.SearchParams>({
    defaultValues,
    serialize,
    deserialize,
    manualSearch: true as const
  })

  const appliedFilters: UsersFilters = {
    keyword: appliedValues.keyword || '',
    roles: appliedValues.roles || [],
    statuses: appliedValues.statuses || []
  }

  const filters: UsersFilters = {
    keyword: tempValues.keyword || '',
    roles: tempValues.roles || [],
    statuses: tempValues.statuses || []
  }

  const pagination: PaginationInfo = {
    page: appliedValues.page ?? DEFAULT_PAGE,
    size: appliedValues.size || DEFAULT_PAGE_SIZE
  }

  return {
    appliedFilters,
    filters,
    pagination,

    setKeyword: (keyword: string) => updateTempValues({ keyword }),
    setRoles: (roles: AppType.AccountRole[]) => updateTempValues({ roles }),
    setStatuses: (statuses: AppType.AccountStatus[]) => updateTempValues({ statuses }),
    setPage: (page: number) => updateAppliedValues({ page }),

    applySearch: () => originalApplySearch({ page: DEFAULT_PAGE }),

    reset,
    isInitialized
  }
}