'use client'

import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { toast } from 'sonner'
import { FormActions } from '@repo/ui/form/form-actions'
import { ConfirmDialog } from '@repo/ui/confirm-dialog'
import { AccountSchema } from '@repo/forms/schemas/account-schema'
import { InlineInputField } from '@repo/forms/fields/inline/inline-input-field'
import { useSmartSheet } from '@repo/ui/smart-sheet'
import { useCreateAccount } from '@/src/hooks/useAccountQueries'
import type { AccountDto } from '@repo/common/model/dto/account-dto'

interface AccountCreateFormProps {
  onSuccess?: () => void
}

export function AccountCreateForm({ onSuccess }: AccountCreateFormProps) {
  const { mutate, isPending } = useCreateAccount()
  const { closeTopSheet } = useSmartSheet()
  const [pendingData, setPendingData] = useState<AccountDto.CreateForm | null>(null)
  const { control, handleSubmit, reset } = useForm<AccountSchema.CreateFormValues>({
    resolver: zodResolver(AccountSchema.CreateSchema),
    defaultValues: { id: '', name: '', password: '', confirmPassword: '', email: '' },
  })

  const onSubmit = handleSubmit((data) => {
    setPendingData({ id: data.id, name: data.name, password: data.password, email: data.email })
  })

  const handleConfirm = () => {
    if (!pendingData) return
    mutate(pendingData, {
      onSuccess: () => {
        toast.success('계정이 등록되었습니다.')
        reset()
        setPendingData(null)
        onSuccess?.()
        closeTopSheet()
      },
      onError: () => setPendingData(null),
    })
  }

  return (
    <form onSubmit={onSubmit} className="space-y-4">
      <InlineInputField control={control} name="id" label="아이디 *" placeholder="예: admin001" />
      <InlineInputField control={control} name="name" label="이름 *" placeholder="예: 홍길동" />
      <InlineInputField control={control} name="email" label="이메일 *" type="email" placeholder="이메일" />
      <InlineInputField control={control} name="password" label="비밀번호 *" type="password" placeholder="비밀번호" />
      <InlineInputField control={control} name="confirmPassword" label="비밀번호 확인 *" type="password" placeholder="비밀번호 확인" />

      <FormActions isEditing isPending={isPending} saveLabel="등록" />

      <ConfirmDialog
        open={!!pendingData}
        onOpenChange={(open) => !open && setPendingData(null)}
        onConfirm={handleConfirm}
        title="계정 등록"
        description={<>아이디 <strong>{pendingData?.id}</strong> 계정을 등록하시겠습니까?</>}
        confirmLabel="등록"
        isPending={isPending}
      />
    </form>
  )
}
