import type { DashboardDto } from '@repo/common/model/dto/dashboard-dto'
import { mockResponse } from './mock-utils'

export const MockDashboardApi = {
  getStats: () => mockResponse<DashboardDto.Stats>({
    totalAccounts: 128,
    activeAccounts: 112,
    weeklyTrend: [
      { date: '2026-03-24', count: 12 },
      { date: '2026-03-25', count: 19 },
      { date: '2026-03-26', count: 8 },
      { date: '2026-03-27', count: 24 },
      { date: '2026-03-28', count: 17 },
      { date: '2026-03-29', count: 5 },
      { date: '2026-03-30', count: 3 },
    ],
    statusCounts: [
      { status: 'ACTIVE', count: 112 },
      { status: 'INACTIVE', count: 10 },
      { status: 'PENDING', count: 4 },
      { status: 'DELETED', count: 2 },
    ],
    recentAccounts: [
      { no: 1, id: 'user001', name: '김철수', email: 'user001@example.com', roles: ['USER'], status: 'ACTIVE', createdAt: '2026-03-24T00:00:00' },
      { no: 2, id: 'user002', name: '이영희', email: 'user002@example.com', roles: ['USER'], status: 'ACTIVE', createdAt: '2026-03-23T00:00:00' },
      { no: 3, id: 'admin01', name: '박관리', email: 'admin01@example.com', roles: ['ADMIN'], status: 'ACTIVE', createdAt: '2026-03-22T00:00:00' },
      { no: 4, id: 'user003', name: '최민준', email: 'user003@example.com', roles: ['USER'], status: 'INACTIVE', createdAt: '2026-03-21T00:00:00' },
      { no: 5, id: 'user004', name: '정수연', email: 'user004@example.com', roles: ['USER'], status: 'ACTIVE', createdAt: '2026-03-20T00:00:00' },
    ],
  }),
}
