'use client'

import type { ComponentProps } from 'react'
import { Controller, type Control, type FieldPath, type FieldValues } from 'react-hook-form'
import { Label } from '@repo/ui/label'
import { InlineBadgeSelect } from '@repo/ui/form/inline-badge-select'
import { FieldError } from '@repo/ui/form/field-error'

type InlineBadgeSelectProps = ComponentProps<typeof InlineBadgeSelect>

interface InlineBadgeSelectFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
> extends Omit<InlineBadgeSelectProps, 'value' | 'onChange' | 'isEditing'> {
  control: Control<TFieldValues>
  name: TName
  label: string
  isEditing?: boolean
}

export function InlineBadgeSelectField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
>({
  control,
  name,
  label,
  isEditing = true,
  ...selectProps
}: InlineBadgeSelectFieldProps<TFieldValues, TName>) {
  return (
    <div className="space-y-1">
      <Label className="text-xs text-muted-foreground">{label}</Label>
      <Controller
        control={control}
        name={name}
        render={({ field, fieldState }) => (
          <>
            <InlineBadgeSelect
              {...selectProps}
              isEditing={isEditing}
              value={field.value}
              onChange={field.onChange}
            />
            <FieldError message={fieldState.error?.message} />
          </>
        )}
      />
    </div>
  )
}
