import type { ResponseModel } from '@repo/common/model/response-model'
import type { AccountDto } from '@repo/common/model/dto/account-dto'
import type { PageListDto } from '@repo/common/model/page-list-dto'
import { AccountApi as ServerAccountApi } from '../api/account-api'
import { getDataSourceType } from '../core/runtime'
import { MockAccountApi } from '../mock/account-mock'

function getAccountApi() {
  return getDataSourceType() === 'server' ? ServerAccountApi : MockAccountApi
}

export const list = (
  params: AccountDto.SearchParams
): Promise<ResponseModel<PageListDto.Response<AccountDto.Summary>>> => {
  return getAccountApi().list(params).then((response) => response.data)
}

export const getDetail = (
  accountId: string
): Promise<ResponseModel<AccountDto.Detail>> => {
  return getAccountApi().getDetail(accountId).then((response) => response.data)
}

export const me = (): Promise<ResponseModel<AccountDto.Detail>> => {
  return getAccountApi().me().then((response) => response.data)
}

export const updateMe = (
  form: AccountDto.UpdateForm
): Promise<ResponseModel<AccountDto.Detail>> => {
  return getAccountApi().updateMe(form).then((response) => response.data)
}

export const changeMyPassword = (
  form: AccountDto.ChangePasswordForm
): Promise<ResponseModel<void>> => {
  return getAccountApi().changeMyPassword(form).then((response) => response.data)
}

export const sendMyPasswordChangeCode = (): Promise<ResponseModel<void>> => {
  return getAccountApi().sendMyPasswordChangeCode().then((response) => response.data)
}

export const changeMyPasswordByCode = (
  form: AccountDto.ChangePasswordByCodeForm
): Promise<ResponseModel<void>> => {
  return getAccountApi().changeMyPasswordByCode(form).then((response) => response.data)
}

export const createAccount = (
  form: AccountDto.CreateForm
): Promise<ResponseModel<AccountDto.Detail>> => {
  return getAccountApi().createAccount(form).then((response) => response.data)
}

export const editAccount = (
  accountId: string,
  form: AccountDto.EditForm
): Promise<ResponseModel<AccountDto.Detail>> => {
  return getAccountApi().editAccount(accountId, form).then((response) => response.data)
}

export const changePasswordByAdmin = (
  accountId: string,
  form: AccountDto.AdminChangePasswordForm
): Promise<ResponseModel<void>> => {
  return getAccountApi().changePasswordByAdmin(accountId, form).then((response) => response.data)
}
