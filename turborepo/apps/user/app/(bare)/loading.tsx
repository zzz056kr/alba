import { Skeleton } from '@repo/ui/skeleton'

export default function BareLoading() {
  return (
    <div className="flex flex-1 items-center justify-center px-4 py-12">
      <div className="w-full max-w-md space-y-6">
        <div className="space-y-2 text-center">
          <Skeleton className="mx-auto h-8 w-32" />
          <Skeleton className="mx-auto h-4 w-48" />
        </div>
        <div className="space-y-3">
          <Skeleton className="h-11 w-full rounded-md" />
          <Skeleton className="h-11 w-full rounded-md" />
          <Skeleton className="h-11 w-full rounded-md" />
        </div>
      </div>
    </div>
  )
}