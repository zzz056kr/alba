'use client'

import type { ComponentProps } from 'react'
import type { Control, FieldPath, FieldValues } from 'react-hook-form'
import { MultiSelect } from '@repo/ui/multi-select'
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@repo/forms/form'

interface FormMultiSelectFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
> extends Omit<ComponentProps<typeof MultiSelect>, 'selected' | 'onChange'> {
  control: Control<TFieldValues>
  name: TName
  label?: string
  description?: string
}

export function FormMultiSelectField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
>({
  control,
  name,
  label,
  description,
  ...selectProps
}: FormMultiSelectFieldProps<TFieldValues, TName>) {
  return (
    <FormField
      control={control}
      name={name}
      render={({ field }) => (
        <FormItem>
          {label ? <FormLabel>{label}</FormLabel> : null}
          <FormControl>
            <MultiSelect
              {...selectProps}
              selected={Array.isArray(field.value) ? field.value : []}
              onChange={field.onChange}
            />
          </FormControl>
          {description ? <FormDescription>{description}</FormDescription> : null}
          <FormMessage />
        </FormItem>
      )}
    />
  )
}