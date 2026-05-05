'use client'

import { cn } from '../lib/utils'
import { Badge } from '../badge'
import { MultiSelect, type MultiSelectOption } from '../multi-select'

interface InlineMultiSelectProps {
  value: string[]
  onChange?: (value: string[]) => void
  options: MultiSelectOption[]
  isEditing: boolean
  placeholder?: string
  className?: string
}

export function InlineMultiSelect({
  value,
  onChange,
  options,
  isEditing,
  placeholder = '선택하세요...',
  className,
}: InlineMultiSelectProps) {
  if (!isEditing) {
    const selected = options.filter((o) => value.includes(o.value))
    return (
      <div className={cn('px-3 py-2 rounded-md bg-muted/40 min-h-9 flex flex-wrap gap-1 items-center', className)}>
        {selected.length > 0 ? (
          selected.map((o) => (
            <Badge key={o.value} variant="outline" className="text-xs">
              {o.label}
            </Badge>
          ))
        ) : (
          <span className="text-sm text-muted-foreground">-</span>
        )}
      </div>
    )
  }

  return (
    <MultiSelect
      options={options}
      selected={value}
      onChange={onChange ?? (() => {})}
      placeholder={placeholder}
      className={className}
    />
  )
}