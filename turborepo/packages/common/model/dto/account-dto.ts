import { AppType } from "../../constants/app-type";

export * as AccountDto from './account-dto';

export interface Summary {
  no?: number
  id?: string
  name?: string
  email?: string
  roles?: Array<AppType.AccountRole>
  status?: AppType.AccountStatus
  lastLoginAt?: string
  createdAt?: string
}

export type Detail = Summary

export interface Abbr {
  id?: string
  email?: string
  provider?: AppType.AuthProvider
}

export interface LoginForm {
  id?: string;
  password?: string;
}

export interface UpdateForm {
  email?: string;
}

export interface CreateForm {
  id: string;
  name: string;
  password: string;
  email: string;
}

export interface JoinForm {
  id: string;
  name: string;
  password: string;
  email: string;
}

export interface EditForm {
  name?: string;
  email?: string;
  status?: AppType.AccountStatus;
  roles?: Array<AppType.AccountRole>;
}

export interface ChangePasswordForm {
  currentPassword: string;
  newPassword: string;
}

export interface AdminChangePasswordForm {
  newPassword: string;
}

export interface ChangePasswordByCodeForm {
  code: string;
  newPassword: string;
}

export interface SearchParams {
  page?: number;
  size?: number;
  keyword?: string;
  roles?: Array<AppType.AccountRole>;
  statuses?: Array<AppType.AccountStatus>;
}
