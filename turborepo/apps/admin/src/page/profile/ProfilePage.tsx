'use client'

import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useRouter } from 'next/navigation'
import { useEffect, useState } from 'react'
import { toast } from 'sonner'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@repo/ui/card'
import { Separator } from '@repo/ui/separator'
import { Label } from '@repo/ui/label'
import { Badge } from '@repo/ui/badge'
import { Skeleton } from '@repo/ui/skeleton'
import { Button } from '@repo/ui/button'
import { useAuthStore } from '@repo/api-client/store/auth-store'
import { Form } from '@repo/forms/form'
import { FormInputField } from '@repo/forms/fields/form/form-input-field'
import { AccountSchema } from '@repo/forms/schemas/account-schema'
import { ChangePasswordByCodeSchema, ChangePasswordByCodeFormValues } from '@repo/forms/schemas/email/account-schema'
import { useChangeMyPassword, useChangeMyPasswordByCode, useMe, useSendMyPasswordChangeCode } from '@/src/hooks/useAccountQueries'
import { AppType } from '@repo/common/constants/app-type'

function InfoField({ label, value, isLoading }: { label: string; value?: string | null; isLoading?: boolean }) {
  return (
    <div className="space-y-2">
      <Label>{label}</Label>
      <div className="px-3 py-2 border border-input rounded-md bg-muted text-sm min-h-9 flex items-center">
        {isLoading ? <Skeleton className="h-4 w-32" /> : (value ?? '-')}
      </div>
    </div>
  )
}

export default function ProfilePage() {
  const router = useRouter()
  const { tokenResponse, clearTokenResponse } = useAuthStore()
  const { data: account, isLoading } = useMe()
  const { mutate: changePassword, isPending } = useChangeMyPassword()
  const { mutate: sendCode, isPending: isSendingCode } = useSendMyPasswordChangeCode()
  const { mutate: changePasswordByCode, isPending: isCodeChangePending } = useChangeMyPasswordByCode()
  const [cooldown, setCooldown] = useState(0)

  const roles = tokenResponse?.roles ?? []
  const form = useForm<AccountSchema.ChangePasswordFormValues>({
    resolver: zodResolver(AccountSchema.ChangePasswordSchema),
    defaultValues: { currentPassword: '', newPassword: '', confirmPassword: '' },
  })
  const codeForm = useForm<ChangePasswordByCodeFormValues>({
    resolver: zodResolver(ChangePasswordByCodeSchema),
    defaultValues: { code: '', newPassword: '', confirmPassword: '' },
  })

  useEffect(() => {
    if (cooldown <= 0) return
    const timer = setTimeout(() => setCooldown((value) => value - 1), 1000)
    return () => clearTimeout(timer)
  }, [cooldown])

  const onSubmit = form.handleSubmit((values) => {
    changePassword(
      { currentPassword: values.currentPassword, newPassword: values.newPassword },
      {
        onSuccess: () => {
          clearTokenResponse()
          toast.success('비밀번호가 변경되었습니다. 다시 로그인해주세요.')
          form.reset()
          router.push('/login')
        },
      }
    )
  })

  const onSendCode = () => {
    sendCode(undefined, {
      onSuccess: () => {
        toast.success('인증 코드가 발송되었습니다. 이메일을 확인해주세요.')
        setCooldown(60)
      },
    })
  }

  const onCodeSubmit = codeForm.handleSubmit((values) => {
    changePasswordByCode(
      { code: values.code, newPassword: values.newPassword },
      {
        onSuccess: () => {
          clearTokenResponse()
          toast.success('비밀번호가 변경되었습니다. 다시 로그인해주세요.')
          codeForm.reset()
          router.push('/login')
        },
      }
    )
  })

  return (
    <div className="space-y-6 p-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">내 정보</h1>
        <p className="text-muted-foreground">
          계정 정보를 확인할 수 있습니다.
        </p>
      </div>

      <Separator />

      <Card>
        <CardHeader>
          <CardTitle>계정 정보</CardTitle>
          <CardDescription>현재 로그인된 계정의 기본 정보입니다.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <InfoField label="계정 ID" value={account?.id} isLoading={isLoading} />
            <InfoField label="이름" value={account?.name} isLoading={isLoading} />
            <InfoField label="이메일" value={account?.email} isLoading={isLoading} />

            <div className="space-y-2">
              <Label>권한</Label>
              <div className="px-3 py-2 border border-input rounded-md bg-muted min-h-9">
                <div className="flex gap-1 flex-wrap">
                  {isLoading ? (
                    <Skeleton className="h-5 w-16" />
                  ) : roles.length > 0 ? (
                    roles.map((role) => (
                      <Badge key={String(role)} variant="outline" className="text-xs bg-background">
                        {AppType.AccountRoleInfo[role]?.name ?? String(role)}
                      </Badge>
                    ))
                  ) : (
                    <span className="text-sm text-muted-foreground">권한 없음</span>
                  )}
                </div>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>비밀번호 변경</CardTitle>
          <CardDescription>현재 비밀번호를 확인한 뒤 새 비밀번호로 변경합니다.</CardDescription>
        </CardHeader>
        <CardContent>
          <Form {...form}>
            <form onSubmit={onSubmit} className="space-y-4 max-w-md">
              <FormInputField
                control={form.control}
                name="currentPassword"
                label="현재 비밀번호"
                type="password"
                autoComplete="current-password"
              />
              <FormInputField
                control={form.control}
                name="newPassword"
                label="새 비밀번호"
                type="password"
                autoComplete="new-password"
              />
              <FormInputField
                control={form.control}
                name="confirmPassword"
                label="새 비밀번호 확인"
                type="password"
                autoComplete="new-password"
              />
              <Button type="submit" disabled={isPending}>
                {isPending ? '변경 중...' : '비밀번호 변경'}
              </Button>
            </form>
          </Form>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>인증코드로 비밀번호 변경</CardTitle>
          <CardDescription>내 이메일로 인증코드를 받아 새 비밀번호를 설정합니다.</CardDescription>
        </CardHeader>
        <CardContent>
          <Form {...codeForm}>
            <form onSubmit={onCodeSubmit} className="space-y-4 max-w-md">
              <Button type="button" variant="outline" onClick={onSendCode} disabled={isSendingCode || cooldown > 0}>
                {cooldown > 0 ? `코드 재발송 (${cooldown}초)` : isSendingCode ? '발송 중...' : '인증 코드 발송'}
              </Button>
              <FormInputField
                control={codeForm.control}
                name="code"
                label="인증 코드"
                inputMode="numeric"
                maxLength={6}
                autoComplete="one-time-code"
              />
              <FormInputField
                control={codeForm.control}
                name="newPassword"
                label="새 비밀번호"
                type="password"
                autoComplete="new-password"
              />
              <FormInputField
                control={codeForm.control}
                name="confirmPassword"
                label="새 비밀번호 확인"
                type="password"
                autoComplete="new-password"
              />
              <Button type="submit" disabled={isCodeChangePending}>
                {isCodeChangePending ? '변경 중...' : '코드로 비밀번호 변경'}
              </Button>
            </form>
          </Form>
        </CardContent>
      </Card>
    </div>
  )
}
