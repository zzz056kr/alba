'use client'

import type { ComponentProps } from 'react'
import { Controller, type Control, type FieldPath, type FieldValues } from 'react-hook-form'
import { Label } from '@repo/ui/label'
import { InlineMultiSelect } from '@repo/ui/form/inline-multi-select'
import { FieldError } from '@repo/ui/form/field-error'

type InlineMultiSelectProps = ComponentProps<typeof InlineMultiSelect>

interface InlineMultiSelectFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
> extends Omit<InlineMultiSelectProps, 'value' | 'onChange' | 'isEditing'> {
  control: Control<TFieldValues>
  name: TName
  label: string
  isEditing?: boolean
}

export function InlineMultiSelectField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
>({
  control,
  name,
  label,
  isEditing = true,
  ...selectProps
}: InlineMultiSelectFieldProps<TFieldValues, TName>) {
  return (
    <div className="space-y-1">
      <Label className="text-xs text-muted-foreground">{label}</Label>
      <Controller
        control={control}
        name={name}
        render={({ field, fieldState }) => (
          <>
            <InlineMultiSelect
              {...selectProps}
              isEditing={isEditing}
              value={Array.isArray(field.value) ? field.value : []}
              onChange={field.onChange}
            />
            <FieldError message={fieldState.error?.message} />
          </>
        )}
      />
    </div>
  )
}
