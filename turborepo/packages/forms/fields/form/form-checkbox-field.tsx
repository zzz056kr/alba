'use client'

import type { ComponentProps } from 'react'
import type { Control, FieldPath, FieldValues } from 'react-hook-form'
import { Checkbox } from '@repo/ui/checkbox'
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@repo/forms/form'

interface FormCheckboxFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
> extends Omit<
    ComponentProps<typeof Checkbox>,
    'checked' | 'onCheckedChange' | 'defaultChecked' | 'name'
  > {
  control: Control<TFieldValues>
  name: TName
  label?: string
  description?: string
}

export function FormCheckboxField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
>({
  control,
  name,
  label,
  description,
  ...checkboxProps
}: FormCheckboxFieldProps<TFieldValues, TName>) {
  return (
    <FormField
      control={control}
      name={name}
      render={({ field }) => (
        <FormItem className="flex flex-row items-start gap-3 space-y-0">
          <FormControl>
            <Checkbox
              {...checkboxProps}
              checked={!!field.value}
              onCheckedChange={field.onChange}
              onBlur={field.onBlur}
              ref={field.ref}
            />
          </FormControl>
          {(label || description) && (
            <div className="space-y-1 leading-none">
              {label ? <FormLabel>{label}</FormLabel> : null}
              {description ? <FormDescription>{description}</FormDescription> : null}
              <FormMessage />
            </div>
          )}
        </FormItem>
      )}
    />
  )
}