export type DataSourceType = 'server' | 'mock'

function normalizeDataSource(value: string | undefined): string | undefined {
  return value?.trim().toLowerCase()
}

export function getDataSourceType(): DataSourceType {
  const value = normalizeDataSource(process.env.NEXT_PUBLIC_DATA_SOURCE)

  return value === 'server' ? 'server' : 'mock'
}

export function isMockDataSource(): boolean {
  return getDataSourceType() === 'mock'
}
