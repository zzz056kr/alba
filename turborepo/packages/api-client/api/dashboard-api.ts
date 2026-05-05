import type { ResponseModel } from '@repo/common/model/response-model'
import type { DashboardDto } from '@repo/common/model/dto/dashboard-dto'
import { http } from '../core/http'

export const DashboardApi = {
  getStats: () =>
    http.get<ResponseModel<DashboardDto.Stats>>('/dashboard/stats'),
}
