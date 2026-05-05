'use client'

import type { ComponentProps } from 'react'
import type { Control, FieldPath, FieldValues } from 'react-hook-form'
import { Textarea } from '@repo/ui/textarea'
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@repo/forms/form'

interface FormTextareaFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
> extends Omit<
    ComponentProps<typeof Textarea>,
    'value' | 'onChange' | 'defaultValue' | 'name'
  > {
  control: Control<TFieldValues>
  name: TName
  label?: string
  description?: string
}

export function FormTextareaField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
>({
  control,
  name,
  label,
  description,
  ...textareaProps
}: FormTextareaFieldProps<TFieldValues, TName>) {
  return (
    <FormField
      control={control}
      name={name}
      render={({ field }) => (
        <FormItem>
          {label ? <FormLabel>{label}</FormLabel> : null}
          <FormControl>
            <Textarea
              {...textareaProps}
              value={field.value ?? ''}
              onBlur={field.onBlur}
              ref={field.ref}
              onChange={(e) => field.onChange(e.target.value)}
            />
          </FormControl>
          {description ? <FormDescription>{description}</FormDescription> : null}
          <FormMessage />
        </FormItem>
      )}
    />
  )
}