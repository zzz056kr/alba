import { AppType } from '@repo/common/constants/app-type'
import type { AccountDto } from '@repo/common/model/dto/account-dto'

// 공통 페이지네이션 정보
export interface PaginationInfo {
  page: number
  size: number
}

// 공통 검색 액션들 (제네릭)
export interface SearchActions<T> {
  handleSearch: () => void
  handleReset: () => void
  handlePageChange: (page: number) => void
  handleFilterChange: T
}

// 공통 페이지 상태
export interface BasePageState {
  currentPage: number
  totalCount: number
  totalPages: number
  isLoading: boolean
  error: Error | null
  isInitialized: boolean
}

// 기본 검색 필터
export interface BaseFilters {
  keyword: string
}

// 사용자 검색 필터 (UI 표시용)
export interface UsersFilters extends BaseFilters {
  roles: AppType.AccountRole[]
  statuses: AppType.AccountStatus[]
}

// 사용자 검색 필터 변경 액션들
export interface UsersFilterActions {
  keyword: (value: string) => void
  roles: (value: AppType.AccountRole[]) => void
  statuses: (value: AppType.AccountStatus[]) => void
}

// 사용자 검색 액션들
export type UsersSearchActions = SearchActions<UsersFilterActions>

// 사용자 페이지 상태
export interface UsersPageState extends BasePageState {
  filters: UsersFilters
  accounts: AccountDto.Summary[]
}

// 사용자 페이지 반환 타입 (상태 + 액션)
export interface UsersPageReturn extends UsersPageState, UsersSearchActions {
  handleRowClick: (user: AccountDto.Summary) => void
}
