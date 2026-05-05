import * as z from 'zod'

const passwordMatchRefine = {
  validate: (data: { password?: string; confirmPassword?: string }) => {
    if (data.password && data.password !== data.confirmPassword) return false
    return true
  },
  message: "비밀번호가 일치하지 않습니다",
  path: ["confirmPassword"],
}

export const ChangePasswordByCodeSchema = z.object({
  code: z.string()
    .min(1, "인증 코드를 입력해주세요.")
    .length(6, "인증 코드는 6자리입니다."),
  newPassword: z.string()
    .min(1, "새 비밀번호를 입력해주세요.")
    .min(4, "비밀번호는 최소 4자 이상이어야 합니다")
    .max(100, "비밀번호는 최대 100자까지 입력 가능합니다"),
  confirmPassword: z.string().min(1, "비밀번호 확인은 필수입니다"),
}).refine(passwordMatchRefine.validate, {
  message: passwordMatchRefine.message,
  path: passwordMatchRefine.path,
})

export type ChangePasswordByCodeFormValues = z.infer<typeof ChangePasswordByCodeSchema>