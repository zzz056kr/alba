'use client';

import { AccountSchema } from "@repo/forms/schemas/account-schema";
import { Form } from "@repo/forms/form";
import { FormInputField } from "@repo/forms/fields/form/form-input-field";
import { Button } from "@repo/ui/button";
import { useMutation } from "@tanstack/react-query";
import * as z from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { join } from "@repo/api-client/service/auth-service";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import Link from "next/link";

type RegisterForm = z.infer<typeof AccountSchema.CreateSchema>;

export default function RegisterPage() {
  const router = useRouter()

  const form = useForm<RegisterForm>({
    resolver: zodResolver(AccountSchema.CreateSchema),
    defaultValues: { id: "", name: "", password: "", confirmPassword: "", email: "" },
  })

  const { mutate: register, isPending } = useMutation({
    mutationFn: async (values: RegisterForm) => {
      await join({ id: values.id, name: values.name, password: values.password, email: values.email })
      return values.email
    },
    onSuccess: (email) => {
      toast.success("회원가입이 완료되었습니다. 이메일을 확인해주세요.")
      router.push(`/email-verify?email=${encodeURIComponent(email)}`)
    },
    onError: () => {},
  })

  return (
    <div className="min-h-screen flex items-center justify-center bg-background py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-foreground">
            회원가입
          </h2>
          <p className="mt-2 text-center text-sm text-muted-foreground">
            새 계정을 만드세요
          </p>
        </div>

        <Form {...form}>
          <form className="mt-8 space-y-4" onSubmit={form.handleSubmit((v) => register(v))}>
            <FormInputField
              control={form.control}
              name="id"
              label="아이디"
              autoComplete="username"
              placeholder="영문, 숫자, _, - 사용 가능"
              className="h-11"
            />
            <FormInputField
              control={form.control}
              name="name"
              label="이름"
              autoComplete="name"
              placeholder="이름"
              className="h-11"
            />
            <FormInputField
              control={form.control}
              name="email"
              label="이메일"
              type="email"
              autoComplete="email"
              placeholder="example@email.com"
              className="h-11"
            />
            <FormInputField
              control={form.control}
              name="password"
              label="비밀번호"
              type="password"
              autoComplete="new-password"
              placeholder="비밀번호"
              className="h-11"
            />
            <FormInputField
              control={form.control}
              name="confirmPassword"
              label="비밀번호 확인"
              type="password"
              autoComplete="new-password"
              placeholder="비밀번호 확인"
              className="h-11"
            />

            <Button type="submit" disabled={isPending} className="h-11 w-full mt-2">
              {isPending ? '처리 중...' : '회원가입'}
            </Button>

            <div className="text-center text-sm text-muted-foreground">
              이미 계정이 있으신가요?{' '}
              <Link href="/login" className="text-primary hover:underline font-medium">
                로그인
              </Link>
            </div>
          </form>
        </Form>
      </div>
    </div>
  )
}