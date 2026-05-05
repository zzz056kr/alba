```jsx
'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { zodResolver } from '@hookform/resolvers/zod'
import { useMutation, useQuery } from '@tanstack/react-query'
import { useForm } from 'react-hook-form'
import { toast } from 'sonner'
import { me, changeMyPasswordByCode, sendMyPasswordChangeCode } from '@repo/api-client/service/account-service'
import { useAuthStore } from '@repo/api-client/store/auth-store'
import { AppType, AuthProviderType } from '@repo/common/constants/app-type'
import { Form } from '@repo/forms/form'
import { FormInputField } from '@repo/forms/fields/form/form-input-field'
import { ChangePasswordByCodeSchema, ChangePasswordByCodeFormValues } from '@repo/forms/schemas/email/account-schema'
import { Badge } from '@repo/ui/badge'
import { Button } from '@repo/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@repo/ui/card'
import { Label } from '@repo/ui/label'
import { Separator } from '@repo/ui/separator'
import { Skeleton } from '@repo/ui/skeleton'

function InfoField({
  label,
  value,
  isLoading,
}: {
  label: string
  value?: string | null
  isLoading?: boolean
}) {
  return (
    <div className="space-y-2">
      <Label>{label}</Label>
      <div className="flex min-h-9 items-center rounded-md border border-input bg-muted px-3 py-2 text-sm">
        {isLoading ? <Skeleton className="h-4 w-32" /> : (value ?? '-')}
      </div>
    </div>
  )
}

export default function ProfilePage() {
  const router = useRouter()
  const { tokenResponse, clearTokenResponse } = useAuthStore()
  const [cooldown, setCooldown] = useState(0)
  const roles = tokenResponse?.roles ?? []
  const isLocalAccount = tokenResponse?.account?.provider === AuthProviderType.LOCAL

  const { data: account, isLoading } = useQuery({
    queryKey: ['me'],
    queryFn: async () => {
      const response = await me()
      return response.data
    },
  })

  const codeForm = useForm<ChangePasswordByCodeFormValues>({
    resolver: zodResolver(ChangePasswordByCodeSchema),
    defaultValues: { code: '', newPassword: '', confirmPassword: '' },
  })

  const { mutate: sendCode, isPending: isSendingCode } = useMutation({
    mutationFn: () => sendMyPasswordChangeCode(),
    onSuccess: () => {
      toast.success('인증 코드가 발송되었습니다. 이메일을 확인해주세요.')
      setCooldown(60)
    },
  })

  const { mutate: updatePasswordByCode, isPending: isCodePending } = useMutation({
    mutationFn: (values: ChangePasswordByCodeFormValues) =>
      changeMyPasswordByCode({ code: values.code, newPassword: values.newPassword }),
    onSuccess: () => {
      clearTokenResponse()
      toast.success('비밀번호가 변경되었습니다. 다시 로그인해주세요.')
      codeForm.reset()
      router.push('/login')
    },
  })

  useEffect(() => {
    if (cooldown <= 0) return
    const timer = setTimeout(() => setCooldown((value) => value - 1), 1000)
    return () => clearTimeout(timer)
  }, [cooldown])

  const onCodeSubmit = codeForm.handleSubmit((values) => updatePasswordByCode(values))

  return (
    <div className="mx-auto flex w-full max-w-6xl flex-1 flex-col gap-6 px-4 py-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">내 정보</h1>
        <p className="text-muted-foreground">계정 정보 확인과 비밀번호 변경을 할 수 있습니다.</p>
      </div>

      <Separator />

      <Card>
        <CardHeader>
          <CardTitle>계정 정보</CardTitle>
          <CardDescription>현재 로그인된 계정의 기본 정보입니다.</CardDescription>
        </CardHeader>
        <CardContent className="grid gap-6 md:grid-cols-2">
          <InfoField label="계정 ID" value={account?.id} isLoading={isLoading} />
          <InfoField label="이름" value={account?.name} isLoading={isLoading} />
          <InfoField label="이메일" value={account?.email} isLoading={isLoading} />
          <div className="space-y-2">
            <Label>권한</Label>
            <div className="flex min-h-9 flex-wrap gap-1 rounded-md border border-input bg-muted px-3 py-2">
              {isLoading ? (
                <Skeleton className="h-5 w-16" />
              ) : roles.length > 0 ? (
                roles.map((role) => (
                  <Badge key={String(role)} variant="outline" className="bg-background text-xs">
                    {AppType.AccountRoleInfo[role]?.name ?? String(role)}
                  </Badge>
                ))
              ) : (
                <span className="text-sm text-muted-foreground">권한 없음</span>
              )}
            </div>
          </div>
        </CardContent>
      </Card>

      {isLocalAccount && (
        <Card>
          <CardHeader>
            <CardTitle>인증코드로 비밀번호 변경</CardTitle>
            <CardDescription>내 이메일로 받은 인증코드로 새 비밀번호를 설정합니다.</CardDescription>
          </CardHeader>
          <CardContent>
            <Form {...codeForm}>
              <form className="max-w-md space-y-4" onSubmit={onCodeSubmit}>
                <Button type="button" variant="outline" onClick={() => sendCode()} disabled={isSendingCode || cooldown > 0}>
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
                <Button type="submit" disabled={isCodePending}>
                  {isCodePending ? '변경 중...' : '코드로 비밀번호 변경'}
                </Button>
              </form>
            </Form>
          </CardContent>
        </Card>
      )}
    </div>
  )
}
```