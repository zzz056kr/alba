'use client'

import type { ComponentProps } from 'react'
import type { Control, FieldPath, FieldValues } from 'react-hook-form'
import { Switch } from '@repo/ui/switch'
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@repo/forms/form'

interface FormSwitchFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
> extends Omit<
    ComponentProps<typeof Switch>,
    'checked' | 'onCheckedChange' | 'defaultChecked' | 'name'
  > {
  control: Control<TFieldValues>
  name: TName
  label?: string
  description?: string
}

export function FormSwitchField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
>({
  control,
  name,
  label,
  description,
  ...switchProps
}: FormSwitchFieldProps<TFieldValues, TName>) {
  return (
    <FormField
      control={control}
      name={name}
      render={({ field }) => (
        <FormItem className="flex flex-row items-center justify-between gap-3 rounded-lg border p-3 space-y-0">
          <div className="space-y-0.5">
            {label ? <FormLabel>{label}</FormLabel> : null}
            {description ? <FormDescription>{description}</FormDescription> : null}
            <FormMessage />
          </div>
          <FormControl>
            <Switch
              {...switchProps}
              checked={!!field.value}
              onCheckedChange={field.onChange}
            />
          </FormControl>
        </FormItem>
      )}
    />
  )
}