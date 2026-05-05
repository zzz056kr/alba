'use client'

import type { ComponentProps } from 'react'
import type { Control, FieldPath, FieldValues } from 'react-hook-form'
import { Input } from '@repo/ui/input'
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@repo/forms/form'

interface FormInputFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
> extends Omit<ComponentProps<typeof Input>, 'value' | 'onChange' | 'defaultValue' | 'name'> {
  control: Control<TFieldValues>
  name: TName
  label?: string
  description?: string
}

export function FormInputField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
>({
  control,
  name,
  label,
  description,
  type = 'text',
  ...inputProps
}: FormInputFieldProps<TFieldValues, TName>) {
  const isNumber = type === 'number'

  return (
    <FormField
      control={control}
      name={name}
      render={({ field }) => (
        <FormItem>
          {label ? <FormLabel>{label}</FormLabel> : null}
          <FormControl>
            <Input
              {...inputProps}
              type={type}
              value={field.value ?? ''}
              onBlur={field.onBlur}
              ref={field.ref}
              onChange={(e) => {
                if (isNumber) {
                  const n = e.target.valueAsNumber
                  field.onChange(Number.isNaN(n) ? undefined : n)
                } else {
                  field.onChange(e.target.value)
                }
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