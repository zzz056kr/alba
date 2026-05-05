'use client'

import * as React from 'react'
import { cn } from '../lib/utils'
import { Input } from '../input'

interface InlineInputProps extends Omit<React.ComponentProps<'input'>, 'onChange'> {
  value: string
  onChange?: (value: string) => void
  isEditing: boolean
  emptyText?: string
}

export function InlineInput({ value, onChange, isEditing, emptyText = '-', className, ...props }: InlineInputProps) {
  if (!isEditing) {
    return (
      <div className={cn('px-3 py-2 rounded-md bg-muted/40 text-sm min-h-9 flex items-center', className)}>
        {value || emptyText}
      </div>
    )
  }

  return (
    <Input
      value={value}
      onChange={(e) => onChange?.(e.target.value)}
      className={cn('h-9', className)}
      {...props}
    />
  )
}