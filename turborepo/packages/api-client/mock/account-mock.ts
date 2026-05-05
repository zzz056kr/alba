import type { AccountDto } from '@repo/common/model/dto/account-dto'
import type { PageListDto } from '@repo/common/model/page-list-dto'
import { AppType } from '@repo/common/constants/app-type'
import { mockResponse } from './mock-utils'

const MOCK_ACCOUNTS: AccountDto.Summary[] = [
  {
    no: 1,
    id: 'admin',
    name: '관리자',
    email: 'admin@example.com',
    roles: [AppType.AccountRoleType.ADMIN],
    status: AppType.AccountStatusType.ACTIVE,
    lastLoginAt: '2026-03-05T10:30:00',
    createdAt: '2025-01-01T00:00:00',
  },
  {
    no: 2,
    id: 'superadmin',
    name: '최고 관리자',
    email: 'super@example.com',
    roles: [AppType.AccountRoleType.SUPER_ADMIN, AppType.AccountRoleType.ADMIN],
    status: AppType.AccountStatusType.ACTIVE,
    lastLoginAt: '2026-03-06T09:00:00',
    createdAt: '2025-01-01T00:00:00',
  },
]

export const MockAccountApi = {
  list: (params: AccountDto.SearchParams) => {
    let result = [...MOCK_ACCOUNTS]

    if (params.keyword) {
      const kw = params.keyword.toLowerCase()
      result = result.filter(a =>
        a.id?.toLowerCase().includes(kw) ||
        a.name?.toLowerCase().includes(kw) ||
        a.email?.toLowerCase().includes(kw)
      )
    }

    if (params.roles?.length) {
      result = result.filter(a => a.roles?.some(r => params.roles!.includes(r)))
    }

    if (params.statuses?.length) {
      result = result.filter(a => a.status && params.statuses!.includes(a.status))
    }

    const page = params.page ?? 1
    const size = params.size ?? 20
    const total = result.length
    const pages = Math.max(1, Math.ceil(total / size))
    const list = result.slice((page - 1) * size, page * size)

    return mockResponse<PageListDto.Response<AccountDto.Summary>>({ total, pages, page, list })
  },

  getDetail: (accountId: string) => {
    const account = MOCK_ACCOUNTS.find(a => a.id === accountId) ?? null
    return mockResponse<AccountDto.Detail>(account as AccountDto.Detail)
  },

  me: () => mockResponse<AccountDto.Detail>(MOCK_ACCOUNTS[0] as AccountDto.Detail),

  updateMe: (form: AccountDto.UpdateForm) =>
    mockResponse<AccountDto.Detail>({ ...MOCK_ACCOUNTS[0], ...form } as AccountDto.Detail),

  changeMyPassword: (_form: AccountDto.ChangePasswordForm) =>
    mockResponse<void>(undefined),

  sendMyPasswordChangeCode: () =>
    mockResponse<void>(undefined),

  changeMyPasswordByCode: (_form: AccountDto.ChangePasswordByCodeForm) =>
    mockResponse<void>(undefined),

  createAccount: (form: AccountDto.CreateForm) => {
    const newAccount: AccountDto.Detail = {
      no: MOCK_ACCOUNTS.length + 1,
      id: form.id,
      email: form.email,
      roles: [AppType.AccountRoleType.USER],
      status: AppType.AccountStatusType.ACTIVE,
      createdAt: new Date().toISOString(),
    }
    MOCK_ACCOUNTS.push(newAccount)
    return mockResponse<AccountDto.Detail>(newAccount)
  },

  editAccount: (accountId: string, form: AccountDto.EditForm) => {
    const account = MOCK_ACCOUNTS.find(a => a.id === accountId) ?? MOCK_ACCOUNTS[0]
    return mockResponse<AccountDto.Detail>({ ...account, ...form } as AccountDto.Detail)
  },

  changePasswordByAdmin: (_accountId: string, _form: AccountDto.AdminChangePasswordForm) =>
    mockResponse<void>(undefined),
}
