export namespace DashboardDto {
  export interface Stats {
    totalAccounts: number
    activeAccounts: number
    weeklyTrend: DailySignup[]
    statusCounts: StatusCount[]
    recentAccounts: RecentAccount[]
  }

  export interface DailySignup {
    date: string   // "2026-03-24"
    count: number
  }

  export interface StatusCount {
    status: string
    count: number
  }

  export interface RecentAccount {
    no: number
    id: string
    name?: string
    email?: string
    roles?: string[]
    status?: string
    createdAt: string
  }
}
