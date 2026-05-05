import type { ResponseModel } from '@repo/common/model/response-model'
import type { AccountDto } from '@repo/common/model/dto/account-dto'
import type { PageListDto } from '@repo/common/model/page-list-dto'
import { http } from '../core/http'

const BASE_URL = '/account'

export const AccountApi = {
  list: (params: AccountDto.SearchParams) =>
    http.get<ResponseModel<PageListDto.Response<AccountDto.Summary>>>(`${BASE_URL}/list`, { params }),

  getDetail: (accountId: string) =>
    http.get<ResponseModel<AccountDto.Detail>>(`${BASE_URL}/${accountId}`),

  me: () =>
    http.get<ResponseModel<AccountDto.Detail>>(`${BASE_URL}/me`),

  updateMe: (form: AccountDto.UpdateForm) =>
    http.put<ResponseModel<AccountDto.Detail>>(`${BASE_URL}/me`, form),

  changeMyPassword: (form: AccountDto.ChangePasswordForm) =>
    http.put<ResponseModel<void>>(`${BASE_URL}/me/password`, form),

  sendMyPasswordChangeCode: () =>
    http.post<ResponseModel<void>>(`${BASE_URL}/me/password/code`),

  changeMyPasswordByCode: (form: AccountDto.ChangePasswordByCodeForm) =>
    http.put<ResponseModel<void>>(`${BASE_URL}/me/password/code`, form),

  createAccount: (form: AccountDto.CreateForm) =>
    http.post<ResponseModel<AccountDto.Detail>>(`${BASE_URL}`, form),

  editAccount: (accountId: string, form: AccountDto.EditForm) =>
    http.put<ResponseModel<AccountDto.Detail>>(`${BASE_URL}/${accountId}`, form),

  changePasswordByAdmin: (accountId: string, form: AccountDto.AdminChangePasswordForm) =>
    http.put<ResponseModel<void>>(`${BASE_URL}/${accountId}/password`, form),
}
