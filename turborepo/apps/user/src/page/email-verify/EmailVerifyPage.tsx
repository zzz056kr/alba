'use client';

import { useState, useEffect, useCallback } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import { useMutation } from '@tanstack/react-query'
import { Button } from '@repo/ui/button'
import { Input } from '@repo/ui/input'
import { sendAuthCode, verify } from '@repo/api-client/service/email/email-service'
import { toast } from 'sonner'

const EMAIL_AUTH_TYPE = 'JOIN'
const RESEND_COOLDOWN = 60

export default function EmailVerifyPage() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const email = searchParams.get('email') ?? ''

  const [code, setCode] = useState('')
  const [cooldown, setCooldown] = useState(0)

  const startCooldown = useCallback(() => {
    setCooldown(RESEND_COOLDOWN)
  }, [])

  useEffect(() => {
    if (cooldown <= 0) return
    const timer = setTimeout(() => setCooldown((c) => c - 1), 1000)
    return () => clearTimeout(timer)
  }, [cooldown])

  const { mutate: sendCode, isPending: isSending } = useMutation({
    mutationFn: () => sendAuthCode(email, EMAIL_AUTH_TYPE),
    onSuccess: () => {
      toast.success('인증 코드가 발송되었습니다. 이메일을 확인해주세요.')
      startCooldown()
    },
    onError: () => {},
  })


  const { mutate: verifyCode, isPending: isVerifying } = useMutation({
    mutationFn: () => verify(email, code, EMAIL_AUTH_TYPE),
    onSuccess: () => {
      toast.success('이메일 인증이 완료되었습니다. 로그인해주세요.')
      router.push('/login')
    },
    onError: () => {},
  })

  if (!email) {
    return (
      <div className="flex flex-1 items-center justify-center">
        <p className="text-muted-foreground">잘못된 접근입니다.</p>
      </div>
    )
  }

  return (
    <div className="flex flex-1 items-center justify-center bg-background py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-foreground">
            이메일 인증
          </h2>
          <p className="mt-2 text-center text-sm text-muted-foreground">
            <span className="font-medium text-foreground">{email}</span>으로<br />
            발송된 6자리 인증 코드를 입력해주세요.
          </p>
        </div>

        <div className="space-y-4">
          <Input
            value={code}
            onChange={(e) => setCode(e.target.value)}
            placeholder="인증 코드 6자리"
            maxLength={6}
            className="h-12 text-center text-xl tracking-widest"
            onKeyDown={(e) => {
              if (e.key === 'Enter' && code.length === 6) verifyCode()
            }}
          />

          <Button
            onClick={() => verifyCode()}
            disabled={code.length !== 6 || isVerifying}
            className="h-11 w-full"
          >
            {isVerifying ? '확인 중...' : '인증 확인'}
          </Button>

          <div className="text-center">
            <button
              onClick={() => sendCode()}
              disabled={isSending || cooldown > 0}
              className="text-sm text-muted-foreground hover:text-foreground disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {cooldown > 0
                ? `재발송 (${cooldown}초 후 가능)`
                : isSending
                  ? '발송 중...'
                  : '인증 코드 재발송'}
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}