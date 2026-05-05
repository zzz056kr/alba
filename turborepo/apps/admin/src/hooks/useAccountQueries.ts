import { useQuery, useMutation, useQueryClient, keepPreviousData } from '@tanstack/react-query'
import { getDetail, list, me, createAccount, editAccount, changeMyPassword, changeMyPasswordByCode, changePasswordByAdmin, sendMyPasswordChangeCode } from '@repo/api-client/service/account-service'
import type { AccountDto } from '@repo/common/model/dto/account-dto'

export const accountKeys = {
  list: (params: AccountDto.SearchParams) => ['accounts', 'list', params] as const,
  detail: (id: string) => ['accounts', 'detail', id] as const,
}

export function useAccountList(params: AccountDto.SearchParams, enabled = true) {
  return useQuery({
    queryKey: accountKeys.list(params),
    queryFn: () => list(params).then((response) => response.data),
    enabled,
    placeholderData: keepPreviousData,
  })
}

export function useMe() {
  return useQuery({
    queryKey: ['accounts', 'me'] as const,
    queryFn: () => me().then((response) => response.data),
  })
}

export function useAccountDetail(accountId: string) {
  return useQuery({
    queryKey: accountKeys.detail(accountId),
    queryFn: () => getDetail(accountId).then((response) => response.data),
    enabled: !!accountId,
  })
}

export function useCreateAccount() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (form: AccountDto.CreateForm) => createAccount(form).then((r) => r.data),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['accounts'] }),
  })
}

export function useEditAccount() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: ({ accountId, form }: { accountId: string; form: AccountDto.EditForm }) =>
      editAccount(accountId, form).then((r) => r.data),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['accounts'] }),
  })
}

export function useChangeMyPassword() {
  return useMutation({
    mutationFn: (form: AccountDto.ChangePasswordForm) => changeMyPassword(form).then((r) => r.data),
  })
}

export function useSendMyPasswordChangeCode() {
  return useMutation({
    mutationFn: () => sendMyPasswordChangeCode().then((r) => r.data),
  })
}

export function useChangeMyPasswordByCode() {
  return useMutation({
    mutationFn: (form: AccountDto.ChangePasswordByCodeForm) => changeMyPasswordByCode(form).then((r) => r.data),
  })
}

export function useAdminChangePassword() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: ({ accountId, form }: { accountId: string; form: AccountDto.AdminChangePasswordForm }) =>
      changePasswordByAdmin(accountId, form).then((r) => r.data),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['accounts'] }),
  })
}
