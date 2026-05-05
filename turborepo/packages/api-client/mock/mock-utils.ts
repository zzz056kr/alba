import type { ResponseModel } from '@repo/common/model/response-model'
import type { AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from 'axios'

export function mockResponse<T>(data: T): Promise<AxiosResponse<ResponseModel<T>>> {
  return Promise.resolve({
    data: { data },
    status: 200,
    statusText: 'OK',
    headers: {},
    config: {} as InternalAxiosRequestConfig<T> & AxiosRequestConfig<T>,
  })
}