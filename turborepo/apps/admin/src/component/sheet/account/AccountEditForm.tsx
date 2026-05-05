'use client'

import { useState, useEffect } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { toast } from 'sonner'
import { Separator } from '@repo/ui/separator'
import { Button } from '@repo/ui/button'
import { FormActions } from '@repo/ui/form/form-actions'
import { ConfirmDialog } from '@repo/ui/confirm-dialog'
import { Form } from '@repo/forms/form'
import { FormInputField } from '@repo/forms/fields/form/form-input-field'
import { AppType } from '@repo/common/constants/app-type'
import { useAuthStore } from '@repo/api-client/store/auth-store'
import { AccountSchema } from '@repo/forms/schemas/account-schema'
import { InlineInputField } from '@repo/forms/fields/inline/inline-input-field'
import { InlineBadgeSelectField } from '@repo/forms/fields/inline/inline-badge-select-field'
import { InlineMultiSelectField } from '@repo/forms/fields/inline/inline-multi-select-field'
import { ReadOnlyField } from '@repo/forms/display/read-only-field'
import { useAdminChangePassword, useEditAccount } from '@/src/hooks/useAccountQueries'
import type { AccountDto } from '@repo/common/model/dto/account-dto'

interface AccountEditFormProps {
  account: AccountDto.Detail
  onSuccess?: () => void
}

const ROLE_OPTIONS = Object.entries(AppType.AccountRoleInfo).map(([value, info]) => ({
  value,
  label: (info as { name: string }).name,
}))

const STATUS_OPTIONS = Object.entries(AppType.AccountStatusInfo).map(([value, info]) => ({
  value: value as AppType.AccountStatus,
  label: (info as { name: string }).name,
}))

export function AccountEditForm({ account, onSuccess }: AccountEditFormProps) {
  const { tokenResponse } = useAuthStore()
  const [isEditing, setIsEditing] = useState(false)
  const [confirmOpen, setConfirmOpen] = useState(false)
  const [pendingData, setPendingData] = useState<AccountDto.EditForm | null>(null)
  const isSuperAdmin = (tokenResponse?.roles ?? []).includes(AppType.AccountRoleType.SUPER_ADMIN)
  const { mutate, isPending } = useEditAccount()
  const { mutate: changePassword, isPending: isPasswordPending } = useAdminChangePassword()

  const { control, handleSubmit, reset } = useForm<AccountSchema.EditFormValues>({
    resolver: zodResolver(AccountSchema.EditSchema),
    defaultValues: {
      name: account.name ?? '',
      email: account.email ?? '',
      status: account.status,
      roles: (account.roles ?? []) as string[],
    },
  })

  useEffect(() => {
    reset({
      name: account.name ?? '',
      email: account.email ?? '',
      status: account.status,
      roles: (account.roles ?? []) as string[],
    })
  }, [account, reset])

  const passwordForm = useForm<AccountSchema.AdminChangePasswordFormValues>({
    resolver: zodResolver(AccountSchema.AdminChangePasswordSchema),
    defaultValues: { newPassword: '', confirmPassword: '' },
  })

  const onSubmit = handleSubmit((data) => {
    if (!account.id) return
    setPendingData({
      name: data.name || undefined,
      email: data.email || undefined,
      status: data.status as AppType.AccountStatus | undefined,
      roles: data.roles as AppType.AccountRole[] | undefined,
    })
    setConfirmOpen(true)
  })

  const handleConfirm = () => {
    if (!account.id || !pendingData) return
    mutate(
      { accountId: account.id, form: pendingData },
      {
        onSuccess: () => {
          toast.success('계정이 수정되었습니다.')
          setIsEditing(false)
          setConfirmOpen(false)
          setPendingData(null)
          onSuccess?.()
        },
        onError: () => {
          setConfirmOpen(false)
          setPendingData(null)
        },
      }
    )
  }

  const handleCancel = () => {
    reset({
      name: account.name ?? '',
      email: account.email ?? '',
      status: account.status,
      roles: (account.roles ?? []) as string[],
    })
    setIsEditing(false)
  }

  const onPasswordSubmit = passwordForm.handleSubmit((data) => {
    if (!account.id) return
    changePassword(
      { accountId: account.id, form: { newPassword: data.newPassword } },
      {
        onSuccess: () => {
          toast.success('비밀번호가 변경되었습니다.')
          passwordForm.reset()
        },
      }
    )
  })

  return (
    <div className="space-y-6">
      <form onSubmit={onSubmit} className="space-y-6">
        <div className="space-y-4">
          <h3 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">기본 정보</h3>
          <div className="space-y-3">
            <ReadOnlyField label="계정 ID" value={account.id} />
            <InlineInputField control={control} name="name" label="이름" isEditing={isEditing} />
            <InlineInputField control={control} name="email" label="이메일" type="email" isEditing={isEditing} />
          </div>
        </div>

        <Separator />

        <div className="space-y-4">
          <h3 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">상태 및 권한</h3>
          <div className="space-y-3">
            <InlineBadgeSelectField
              control={control}
              name="status"
              label="상태"
              isEditing={isEditing}
              options={STATUS_OPTIONS}
            />
            <InlineMultiSelectField
              control={control}
              name="roles"
              label="권한"
              isEditing={isEditing}
              options={ROLE_OPTIONS}
              placeholder="권한 선택"
            />
          </div>
        </div>

        <Separator />

        <div className="space-y-4">
          <h3 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">활동 정보</h3>
          <div className="space-y-3">
            <ReadOnlyField
              label="최근 로그인"
              value={account.lastLoginAt ? new Date(account.lastLoginAt).toLocaleString('ko-KR') : undefined}
            />
            <ReadOnlyField
              label="가입일"
              value={account.createdAt ? new Date(account.createdAt).toLocaleString('ko-KR') : undefined}
            />
          </div>
        </div>

        <FormActions
          isEditing={isEditing}
          isPending={isPending}
          onEdit={() => setIsEditing(true)}
          onCancel={handleCancel}
        />

        <ConfirmDialog
          open={confirmOpen}
          onOpenChange={(open) => { setConfirmOpen(open); if (!open) setPendingData(null) }}
          onConfirm={handleConfirm}
          title="계정 수정"
          description={<>아이디 <strong>{account.id}</strong> 계정 정보를 수정하시겠습니까?</>}
          confirmLabel="수정"
          isPending={isPending}
        />
      </form>

      {isSuperAdmin && (
        <>
          <Separator />
          <div className="space-y-4">
            <h3 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">비밀번호 변경</h3>
            <Form {...passwordForm}>
              <form onSubmit={onPasswordSubmit} className="space-y-4">
                <FormInputField
                  control={passwordForm.control}
                  name="newPassword"
                  label="새 비밀번호"
                  type="password"
                  autoComplete="new-password"
                />
                <FormInputField
                  control={passwordForm.control}
                  name="confirmPassword"
                  label="새 비밀번호 확인"
                  type="password"
                  autoComplete="new-password"
                />
                <Button type="submit" disabled={isPasswordPending}>
                  {isPasswordPending ? '변경 중...' : '비밀번호 변경'}
                </Button>
              </form>
            </Form>
          </div>
        </>
      )}
    </div>
  )
}
