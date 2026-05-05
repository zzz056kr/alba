'use client'

import type { ComponentProps } from 'react'
import { Controller, type Control, type FieldPath, type FieldValues } from 'react-hook-form'
import { Label } from '@repo/ui/label'
import { InlineInput } from '@repo/ui/form/inline-input'
import { FieldError } from '@repo/ui/form/field-error'

interface InlineInputFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
> extends Omit<ComponentProps<typeof InlineInput>, 'value' | 'onChange' | 'isEditing'> {
  control: Control<TFieldValues>
  name: TName
  label: string
  isEditing?: boolean
}

export function InlineInputField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
>({
  control,
  name,
  label,
  isEditing = true,
  ...inputProps
}: InlineInputFieldProps<TFieldValues, TName>) {
  return (
    <div className="space-y-1">
      <Label>{label}</Label>
      <Controller
        control={control}
        name={name}
        render={({ field, fieldState }) => (
          <>
            <InlineInput
              {...inputProps}
              isEditing={isEditing}
              value={typeof field.value === 'string' ? field.value : ''}
              onChange={field.onChange}
            />
            <FieldError message={fieldState.error?.message} />
          </>
        )}
      />
    </div>
  )
}
