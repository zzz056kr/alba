'use client'

import { cn } from '../lib/utils'
import { Badge, badgeVariants } from '../badge'
import type { VariantProps } from 'class-variance-authority'

interface Option<T extends string> {
  value: T
  label: string
  variant?: VariantProps<typeof badgeVariants>['variant']
}

interface InlineBadgeSelectProps<T extends string> {
  value: T | undefined
  onChange?: (value: T) => void
  options: Option<T>[]
  isEditing: boolean
  className?: string
}

export function InlineBadgeSelect<T extends string>({
  value,
  onChange,
  options,
  isEditing,
  className,
}: InlineBadgeSelectProps<T>) {
  const selected = options.find((o) => o.value === value)

  if (!isEditing) {
    return (
      <div className={cn('px-3 py-2 rounded-md bg-muted/40 min-h-9 flex items-center', className)}>
        {selected ? (
          <Badge variant={selected.variant ?? 'default'}>{selected.label}</Badge>
        ) : (
          <span className="text-sm text-muted-foreground">-</span>
        )}
      </div>
    )
  }

  return (
    <div className={cn('flex flex-wrap gap-1.5 px-1', className)}>
      {options.map((opt) => (
        <Badge
          key={opt.value}
          variant={value === opt.value ? (opt.variant ?? 'default') : 'outline'}
          className="cursor-pointer select-none"
          onClick={() => onChange?.(opt.value)}
        >
          {opt.label}
        </Badge>
      ))}
    </div>
  )
}