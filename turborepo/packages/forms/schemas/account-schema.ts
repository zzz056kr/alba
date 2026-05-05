import * as z from "zod";
import { AppType } from '@repo/common/constants/app-type';

export * as AccountSchema from "./account-schema";

export const login = z.object({
  id: z.string().min(1, "아이디를 입력해주세요."),
  password: z.string().min(1, "비밀번호를 입력해주세요."),
})

const RoleEnum = z.enum(
  Object.values(AppType.AccountRoleType) as [string, ...string[]]
)

const StatusEnum = z.enum(
  Object.values(AppType.AccountStatusType) as [string, ...string[]]
)

const passwordMatchRefine = {
  validate: (data: { password?: string; confirmPassword?: string }) => {
    if (data.password && data.password !== data.confirmPassword) return false
    return true
  },
  message: "비밀번호가 일치하지 않습니다",
  path: ["confirmPassword"],
}

export const CreateSchema = z.object({
  id: z.string()
    .min(1, "아이디는 필수입니다")
    .min(3, "아이디는 최소 3자 이상이어야 합니다")
    .max(50, "아이디는 최대 50자까지 입력 가능합니다")
    .regex(/^[a-zA-Z0-9_-]+$/, "아이디는 영문, 숫자, _, - 만 사용 가능합니다"),
  name: z.string()
    .min(1, "이름은 필수입니다")
    .max(50, "이름은 최대 50자까지 입력 가능합니다"),
  password: z.string()
    .min(1, "비밀번호는 필수입니다")
    .min(4, "비밀번호는 최소 4자 이상이어야 합니다")
    .max(100, "비밀번호는 최대 100자까지 입력 가능합니다"),
  confirmPassword: z.string().min(1, "비밀번호 확인은 필수입니다"),
  email: z.string()
    .min(1, "이메일은 필수입니다")
    .email("올바른 이메일 형식을 입력해주세요"),
}).refine(passwordMatchRefine.validate, {
  message: passwordMatchRefine.message,
  path: passwordMatchRefine.path,
})

export const EditSchema = z.object({
  name: z.string().max(50, "이름은 최대 50자까지 입력 가능합니다").optional().or(z.literal("")),
  email: z.string().email("올바른 이메일 형식을 입력해주세요").optional().or(z.literal("")),
  status: StatusEnum.optional(),
  roles: z.array(RoleEnum).optional(),
})

export const ChangePasswordSchema = z.object({
  currentPassword: z.string().min(1, "현재 비밀번호를 입력해주세요."),
  newPassword: z.string()
    .min(1, "새 비밀번호를 입력해주세요.")
    .min(4, "비밀번호는 최소 4자 이상이어야 합니다")
    .max(100, "비밀번호는 최대 100자까지 입력 가능합니다"),
  confirmPassword: z.string().min(1, "비밀번호 확인은 필수입니다"),
}).refine(passwordMatchRefine.validate, {
  message: passwordMatchRefine.message,
  path: passwordMatchRefine.path,
})

export const AdminChangePasswordSchema = z.object({
  newPassword: z.string()
    .min(1, "새 비밀번호를 입력해주세요.")
    .min(4, "비밀번호는 최소 4자 이상이어야 합니다")
    .max(100, "비밀번호는 최대 100자까지 입력 가능합니다"),
  confirmPassword: z.string().min(1, "비밀번호 확인은 필수입니다"),
}).refine(passwordMatchRefine.validate, {
  message: passwordMatchRefine.message,
  path: passwordMatchRefine.path,
})

export type CreateFormValues = z.infer<typeof CreateSchema>
export type EditFormValues = z.infer<typeof EditSchema>
export type ChangePasswordFormValues = z.infer<typeof ChangePasswordSchema>
export type AdminChangePasswordFormValues = z.infer<typeof AdminChangePasswordSchema>
