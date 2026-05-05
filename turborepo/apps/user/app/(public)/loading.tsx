import { Skeleton } from '@repo/ui/skeleton'

export default function PublicLoading() {
  return (
    <div className="mx-auto w-full max-w-7xl px-4 py-8 md:px-8 md:py-12">
      {/* Page header */}
      <div className="flex flex-col gap-3">
        <Skeleton className="h-7 w-48" />
        <Skeleton className="h-4 w-full max-w-xl" />
      </div>

      {/* Card grid */}
      <div className="mt-8 grid grid-cols-1 gap-4 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4">
        {Array.from({ length: 8 }).map((_, i) => (
          <div key={i} className="flex flex-col gap-3">
            <Skeleton className="aspect-[2/3] w-full rounded-xl" />
            <Skeleton className="h-4 w-3/4" />
            <Skeleton className="h-3 w-1/2" />
          </div>
        ))}
      </div>
    </div>
  )
}
