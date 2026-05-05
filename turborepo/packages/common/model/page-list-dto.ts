export * as PageListDto from "./page-list-dto";

import { AppType } from '../constants/app-type';

export interface Request {
  page?: number
  size?: number
  order?: string
  direction?: AppType.Sort
  formUseYn?: boolean
}

export interface Response<T> {
  total?: number
  pages?: number
  page?: number
  list?: Array<T>
}
