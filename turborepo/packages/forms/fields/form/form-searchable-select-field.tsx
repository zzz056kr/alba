'use client'

import type { ComponentProps } from 'react'
import type { Control, FieldPath, FieldValues } from 'react-hook-form'
import { SearchableSelect } from '@repo/ui/searchable-select'
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@repo/forms/form'

interface FormSearchableSelectFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
> extends Omit<ComponentProps<typeof SearchableSelect>, 'value' | 'onValueChange'> {
  control: Control<TFieldValues>
  name: TName
  label?: string
  description?: string
  valueType?: 'string' | 'number'
}

export function FormSearchableSelectField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
>({
  control,
  name,
  label,
  description,
  valueType = 'string',
  ...selectProps
}: FormSearchableSelectFieldProps<TFieldValues, TName>) {
  return (
    <FormField
      control={control}
      name={name}
      render={({ field }) => (
        <FormItem>
          {label ? <FormLabel>{label}</FormLabel> : null}
          <FormControl>
            <SearchableSelect
              {...selectProps}
              value={field.value ?? undefined}
              onValueChange={(v) => {
                if (v === undefined) {
                  field.onChange(undefined)
                  return
                }
                field.onChange(valueType === 'number' ? Number(v) : v)
              }}
            />
          </FormControl>
          {description ? <FormDescription>{description}</FormDescription> : null}
          <FormMessage />
        </FormItem>
      )}
    />
  )
}