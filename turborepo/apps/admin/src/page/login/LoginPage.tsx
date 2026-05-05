'use client';

import { AccountSchema } from "@repo/forms/schemas/account-schema";
import { Form } from "@repo/forms/form";
import { FormInputField } from "@repo/forms/fields/form/form-input-field";
import { Button } from "@repo/ui/button";
import {useMutation} from "@tanstack/react-query";
import * as z from "zod";
import {useForm} from "react-hook-form";
import {zodResolver} from "@hookform/resolvers/zod";
import { login as loginService } from "@repo/api-client/service/auth-service";
import { useAuthStore } from '@repo/api-client/store/auth-store';
import { useRouter, useSearchParams } from "next/navigation";
import { toast } from "sonner";
import { useEffect } from "react";

type LoginForm = z.infer<typeof AccountSchema.login>;
export default function LoginPage() {
  const { setTokenResponse } = useAuthStore()
  const router = useRouter()
  const searchParams = useSearchParams()

  useEffect(() => {
    if (searchParams.get('error') === 'oauth_failed') {
      toast.error('소셜 로그인에 실패했습니다. 다시 시도해주세요.')
    }
  }, [searchParams])
  const form = useForm<LoginForm>({
    resolver: zodResolver(AccountSchema.login),
    defaultValues: { id: "", password: "" },
  })

  const { mutate: login, isPending } = useMutation({
    mutationFn: (values: LoginForm) => loginService(values),
    onSuccess: (res) => {
      if (res.data) {
        setTokenResponse(res.data)
        toast.success("로그인 성공! 환영합니다!", {
          duration: 1000,
        })
        router.push("/")
      }
    },
    onError: () => {
      // 자동으로 toast 에러 메시지가 표시됨 (axios interceptor에서 처리)
    },
  })

  const onSubmit = (values: LoginForm) => {
    login(values);
  }

  const ALLOWED_PROVIDERS = ['google', 'kakao', 'naver'] as const
  type AllowedProvider = typeof ALLOWED_PROVIDERS[number]

  const handleSocialLogin = (provider: string) => {
    const normalized = provider.toLowerCase() as AllowedProvider
    if (!ALLOWED_PROVIDERS.includes(normalized)) {
      toast.error('지원하지 않는 로그인 방식입니다.')
      return
    }

    const apiBase = process.env.NEXT_PUBLIC_API_BASE_URL
    const clientBase = process.env.NEXT_PUBLIC_CLIENT_BASE_URL

    if (!clientBase) {
      toast.error('로그인 설정이 올바르지 않습니다.')
      return
    }

    try {
      const redirectUrl = new URL(clientBase)
      window.location.href = `${apiBase}/oauth2/login/${normalized}?redirect_url=${encodeURIComponent(redirectUrl.origin)}`
    } catch {
      toast.error('로그인 설정이 올바르지 않습니다.')
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-background py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        {/* 헤더 */}
        <div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-foreground">
            로그인
          </h2>
          <p className="mt-2 text-center text-sm text-muted-foreground">
            계정에 로그인하세요
          </p>
        </div>

        {/* 로그인 폼 */}
        <Form {...form}>
          <form className="mt-8 space-y-6" onSubmit={form.handleSubmit(onSubmit)}>
            <div className="space-y-3">
              <FormInputField
                control={form.control}
                name="id"
                autoComplete="username"
                placeholder="아이디"
                className="h-11"
              />
              <FormInputField
                control={form.control}
                name="password"
                type="password"
                autoComplete="current-password"
                placeholder="비밀번호"
                className="h-11"
              />
            </div>

            {/* 로그인 버튼 */}
            <div>
              <Button type="submit" disabled={isPending} className="h-11 w-full">
                {isPending ? '로그인 중...' : '로그인'}
              </Button>
            </div>

            {/* 구분선 */}
            <div className="relative">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-border" />
              </div>
              <div className="relative flex justify-center text-sm">
                <span className="px-2 bg-background text-muted-foreground">또는</span>
              </div>
            </div>

            {/* 소셜 로그인 버튼들 */}
            <div className="space-y-3">
              {/* 구글 로그인 */}
              <Button
                type="button"
                variant="outline"
                onClick={() => handleSocialLogin('Google')}
                className="w-full h-10"
              >
                <svg className="w-5 h-5 mr-2" viewBox="0 0 24 24">
                  <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                  <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                  <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                </svg>
                Google로 로그인
              </Button>

              {/* 카카오 로그인 */}
              <Button
                type="button"
                onClick={() => handleSocialLogin('Kakao')}
                className="w-full h-10 bg-yellow-400 text-gray-900 hover:bg-yellow-500"
              >
                <svg className="w-5 h-5 mr-2" viewBox="0 0 24 24" fill="#3C1E1E">
                  <path d="M12 3c5.799 0 10.5 3.664 10.5 8.185 0 4.52-4.701 8.184-10.5 8.184a13.5 13.5 0 0 1-1.727-.11l-4.408 2.883c-.501.265-.678.236-.472-.413l.892-3.678c-2.88-1.46-4.785-3.99-4.785-6.866C1.5 6.665 6.201 3 12 3z"/>
                </svg>
                카카오로 로그인
              </Button>

              {/* 네이버 로그인 */}
              <Button
                type="button"
                onClick={() => handleSocialLogin('Naver')}
                className="w-full h-10 bg-green-500 text-white hover:bg-green-600"
              >
                <svg className="w-5 h-5 mr-2" viewBox="0 0 24 24" fill="white">
                  <path d="M16.273 12.845 7.376 0H0v24h7.727V11.155L16.624 24H24V0h-7.727z"/>
                </svg>
                네이버로 로그인
              </Button>
            </div>
          </form>
        </Form>
      </div>
    </div>
  )
}
