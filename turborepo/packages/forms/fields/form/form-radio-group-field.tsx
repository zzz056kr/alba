'use client'

import type { Control, FieldPath, FieldValues } from 'react-hook-form'
import { RadioGroup, RadioGroupItem } from '@repo/ui/radio-group'
import {
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@repo/forms/form'

export interface FormRadioOption<TValue extends string | number = string | number> {
  value: TValue
  label: string
  disabled?: boolean
}

interface FormRadioGroupFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
  TValue extends string | number = string | number,
> {
  control: Control<TFieldValues>
  name: TName
  label?: string
  description?: string
  options: ReadonlyArray<FormRadioOption<TValue>>
  valueType?: 'string' | 'number'
  disabled?: boolean
  className?: string
  orientation?: 'horizontal' | 'vertical'
}

export function FormRadioGroupField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
  TValue extends string | number = string | number,
>({
  control,
  name,
  label,
  description,
  options,
  valueType = 'string',
  disabled,
  className,
  orientation = 'vertical',
}: FormRadioGroupFieldProps<TFieldValues, TName, TValue>) {
  return (
    <FormField
      control={control}
      name={name}
      render={({ field }) => (
        <FormItem className={className}>
          {label ? <FormLabel>{label}</FormLabel> : null}
          <FormControl>
            <RadioGroup
              value={field.value === undefined || field.value === null ? '' : String(field.value)}
              onValueChange={(v) =>
                field.onChange(valueType === 'number' ? Number(v) : v)
              }
              disabled={disabled}
              className={orientation === 'horizontal' ? 'flex flex-row gap-4' : 'grid gap-2'}
            >
              {options.map((opt) => {
                const id = `${String(name)}-${String(opt.value)}`
                return (
                  <label
                    key={String(opt.value)}
                    htmlFor={id}
                    className="flex items-center gap-2 text-sm font-normal cursor-pointer data-[disabled]:cursor-not-allowed data-[disabled]:opacity-50"
                    data-disabled={opt.disabled || disabled || undefined}
                  >
                    <RadioGroupItem
                      id={id}
                      value={String(opt.value)}
                      disabled={opt.disabled || disabled}
                    />
                    {opt.label}
                  </label>
                )
              })}
            </RadioGroup>
          </FormControl>
          {description ? <FormDescription>{description}</FormDescription> : null}
          <FormMessage />
        </FormItem>
      )}
    />
  )
}