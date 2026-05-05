'use client'

import type { Control, FieldPath, FieldValues } from 'react-hook-form'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@repo/ui/select'
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@repo/forms/form'

export interface FormSelectOption<TValue extends string | number = string | number> {
  value: TValue
  label: string
  disabled?: boolean
}

interface FormSelectFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
  TValue extends string | number = string | number,
> {
  control: Control<TFieldValues>
  name: TName
  label?: string
  description?: string
  placeholder?: string
  options: ReadonlyArray<FormSelectOption<TValue>>
  valueType?: 'string' | 'number'
  disabled?: boolean
  className?: string
  triggerClassName?: string
}

export function FormSelectField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
  TValue extends string | number = string | number,
>({
  control,
  name,
  label,
  description,
  placeholder,
  options,
  valueType = 'string',
  disabled,
  className,
  triggerClassName,
}: FormSelectFieldProps<TFieldValues, TName, TValue>) {
  return (
    <FormField
      control={control}
      name={name}
      render={({ field }) => (
        <FormItem className={className}>
          {label ? <FormLabel>{label}</FormLabel> : null}
          <Select
            value={field.value === undefined || field.value === null ? '' : String(field.value)}
            onValueChange={(v) =>
              field.onChange(valueType === 'number' ? Number(v) : v)
            }
            disabled={disabled}
          >
            <FormControl>
              <SelectTrigger className={triggerClassName}>
                <SelectValue placeholder={placeholder} />
              </SelectTrigger>
            </FormControl>
            <SelectContent>
              {options.map((opt) => (
                <SelectItem
                  key={String(opt.value)}
                  value={String(opt.value)}
                  disabled={opt.disabled}
                >
                  {opt.label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          {description ? <FormDescription>{description}</FormDescription> : null}
          <FormMessage />
        </FormItem>
      )}
    />
  )
}