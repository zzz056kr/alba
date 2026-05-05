'use client'

import { Controller, type Control, type FieldPath, type FieldValues } from 'react-hook-form'
import { Label } from '@repo/ui/label'
import { Button } from '@repo/ui/button'
import { FieldError } from '@repo/ui/form/field-error'

interface ButtonSelectOption<TValue extends string> {
  value: TValue
  label: string
}

interface ButtonSelectFieldProps<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
  TValue extends string,
> {
  control: Control<TFieldValues>
  name: TName
  label: string
  options: ButtonSelectOption<TValue>[]
  onValueChange?: (value: TValue) => void
}

export function ButtonSelectField<
  TFieldValues extends FieldValues,
  TName extends FieldPath<TFieldValues>,
  TValue extends string,
>({
  control,
  name,
  label,
  options,
  onValueChange,
}: ButtonSelectFieldProps<TFieldValues, TName, TValue>) {
  return (
    <div className="space-y-1">
      <Label>{label}</Label>
      <Controller
        control={control}
        name={name}
        render={({ field, fieldState }) => (
          <>
            <div className="flex gap-2">
              {options.map((option) => (
                <Button
                  key={option.value}
                  type="button"
                  variant={field.value === option.value ? 'default' : 'outline'}
                  size="sm"
                  className="flex-1"
                  onClick={() => {
                    field.onChange(option.value)
                    onValueChange?.(option.value)
                  }}
                >
                  {option.label}
                </Button>
              ))}
            </div>
            <FieldError message={fieldState.error?.message} />
          </>
        )}
      />
    </div>
  )
}
