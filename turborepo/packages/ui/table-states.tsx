import { TableCell, TableRow } from "./table"
import { Skeleton } from "./skeleton"

interface LoadingStateProps {
  colSpan: number
  rows?: number
}

export function LoadingState({ colSpan, rows = 5 }: LoadingStateProps) {
  return (
    <>
      {Array.from({ length: rows }).map((_, i) => (
        <TableRow key={i}>
          <TableCell colSpan={colSpan} className="py-3">
            <Skeleton className="h-4 w-full" />
          </TableCell>
        </TableRow>
      ))}
    </>
  )
}

interface ErrorStateProps {
  colSpan: number
  message?: string
}

export function ErrorState({ colSpan, message = "데이터를 불러오는 중 오류가 발생했습니다." }: ErrorStateProps) {
  return (
    <TableRow>
      <TableCell colSpan={colSpan} className="text-center py-8 text-destructive">
        {message}
      </TableCell>
    </TableRow>
  )
}

interface EmptyStateProps {
  colSpan: number
  message?: string
}

export function EmptyState({ colSpan, message = "검색 결과가 없습니다." }: EmptyStateProps) {
  return (
    <TableRow>
      <TableCell colSpan={colSpan} className="text-center py-8 text-muted-foreground">
        {message}
      </TableCell>
    </TableRow>
  )
}