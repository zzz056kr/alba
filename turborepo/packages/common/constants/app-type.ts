export * as AppType from "./app-type"

export const SortType = {
  ASC: 'ASC',
  DESC: 'DESC'
} as const
export type Sort = typeof SortType[keyof typeof SortType]

export const AuthProviderType = {
  LOCAL: 'LOCAL',
  GOOGLE: 'GOOGLE',
  KAKAO: 'KAKAO',
  NAVER: 'NAVER'
} as const
export type AuthProvider = typeof AuthProviderType[keyof typeof AuthProviderType]

export const AccountRoleType = {
  GUEST: 'GUEST',
  USER: 'USER',
  ADMIN: 'ADMIN',
  SUPER_ADMIN: 'SUPER_ADMIN'
} as const
export type AccountRole = typeof AccountRoleType[keyof typeof AccountRoleType]

export const AuthProviderCodeType = {
  L: 'L',
  G: 'G',
  K: 'K',
  N: 'N'
} as const
export type AuthProviderCode = typeof AuthProviderCodeType[keyof typeof AuthProviderCodeType]

export const AccountStatusType = {
  PENDING: 'PENDING',
  ACTIVE: 'ACTIVE',
  INACTIVE: 'INACTIVE',
  DELETED: 'DELETED',
} as const
export type AccountStatus = typeof AccountStatusType[keyof typeof AccountStatusType]

export const AccountRoleInfo: Record<AccountRole, { name: string }> = {
  GUEST: { name: '손님' },
  USER: { name: '일반 사용자' },
  ADMIN: { name: '관리자' },
  SUPER_ADMIN: { name: '최고 관리자' },
}

export const AccountStatusInfo: Record<AccountStatus, { name: string; variant: 'default' | 'secondary' | 'destructive' | 'outline' }> = {
  PENDING: { name: '대기', variant: 'secondary' },
  ACTIVE: { name: '활성', variant: 'default' },
  INACTIVE: { name: '비활성', variant: 'outline' },
  DELETED: { name: '삭제됨', variant: 'destructive' },
}
