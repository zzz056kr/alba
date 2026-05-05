import type { ResponseModel } from '@repo/common/model/response-model'
import type { DashboardDto } from '@repo/common/model/dto/dashboard-dto'
import { DashboardApi as ServerDashboardApi } from '../api/dashboard-api'
import { MockDashboardApi } from '../mock/dashboard-mock'
import { getDataSourceType } from '../core/runtime'

function getDashboardApi() {
  return getDataSourceType() === 'server' ? ServerDashboardApi : MockDashboardApi
}

export const getStats = (): Promise<ResponseModel<DashboardDto.Stats>> =>
  getDashboardApi().getStats().then((res) => res.data)
