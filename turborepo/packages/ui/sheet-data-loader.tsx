import { ReactNode } from 'react'
import { Skeleton } from './skeleton'

interface SheetDataLoaderProps<T> {
  isLoading: boolean
  error: Error | null | undefined
  data: T | null | undefined
  resourceName: string
  loadingMessage?: string
  children: (data: T) => ReactNode
}

export function SheetDataLoader<T>({
  isLoading,
  error,
  data,
  resourceName,
  loadingMessage,
  children
}: SheetDataLoaderProps<T>) {
  if (isLoading) {
    return (
      <div className="space-y-4 py-8">
        <Skeleton className="h-4 w-1/2" />
        <Skeleton className="h-4 w-3/4" />
        <Skeleton className="h-4 w-2/3" />
        <p className="text-sm text-muted-foreground text-center mt-4">
          {loadingMessage || `${resourceName} 정보를 불러오는 중...`}
        </p>
      </div>
    )
  }

  if (error) {
    return (
      <div className="flex items-center justify-center py-8">
        <p className="text-sm text-destructive">
          {resourceName} 정보를 불러오는데 실패했습니다.
        </p>
      </div>
    )
  }

  if (!data) {
    return (
      <div className="flex items-center justify-center py-8">
        <p className="text-sm text-muted-foreground">
          {resourceName}를 찾을 수 없습니다.
        </p>
      </div>
    )
  }

  return <>{children(data)}</>
}
