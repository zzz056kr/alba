"use client"

import * as React from "react"
import { Check, ChevronDown, X } from "lucide-react"
import { cn } from "./lib/utils"
import { Badge } from "./badge"
import { Button } from "./button"
import { Popover, PopoverContent, PopoverTrigger } from "./popover"

export interface MultiSelectOption {
  value: string
  label: string
}

interface MultiSelectProps {
  options: MultiSelectOption[]
  selected: string[]
  onChange: (selected: string[]) => void
  placeholder?: string
  className?: string
  disabled?: boolean
}

export function MultiSelect({
  options,
  selected,
  onChange,
  placeholder = "선택하세요...",
  className,
  disabled = false,
}: MultiSelectProps) {
  const [open, setOpen] = React.useState(false)
  const [focusedIndex, setFocusedIndex] = React.useState<number>(-1)

  const handleSelect = (value: string) => {
    if (disabled) return
    if (selected.includes(value)) {
      onChange(selected.filter((item) => item !== value))
    } else {
      onChange([...selected, value])
    }
  }

  const handleRemove = (value: string) => {
    if (disabled) return
    onChange(selected.filter((item) => item !== value))
  }

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (!open) {
      if (e.key === "ArrowDown" || e.key === "Enter" || e.key === " ") {
        e.preventDefault()
        setOpen(true)
        setFocusedIndex(0)
      }
      return
    }
    switch (e.key) {
      case "ArrowDown":
        e.preventDefault()
        setFocusedIndex((prev) => (prev < options.length - 1 ? prev + 1 : prev))
        break
      case "ArrowUp":
        e.preventDefault()
        setFocusedIndex((prev) => (prev > 0 ? prev - 1 : prev))
        break
      case "Enter":
      case " ":
        e.preventDefault()
        if (focusedIndex >= 0 && focusedIndex < options.length) {
          handleSelect(options[focusedIndex].value)
        }
        break
      case "Escape":
        e.preventDefault()
        setOpen(false)
        setFocusedIndex(-1)
        break
    }
  }

  React.useEffect(() => {
    if (!open) setFocusedIndex(-1)
  }, [open])

  return (
    <div
      onKeyDown={disabled ? undefined : handleKeyDown}
      tabIndex={disabled ? -1 : 0}
      className="focus:outline-none"
    >
      <Popover open={disabled ? false : open} onOpenChange={disabled ? undefined : setOpen}>
        <PopoverTrigger asChild>
          <Button
            variant="outline"
            role="combobox"
            aria-expanded={open}
            disabled={disabled}
            className={cn("w-full justify-between min-h-10 h-auto", className)}
          >
            <div className="flex flex-wrap gap-1 overflow-hidden">
              {selected.length === 0 ? (
                <span className="text-muted-foreground">{placeholder}</span>
              ) : (
                selected.map((value) => {
                  const option = options.find((opt) => opt.value === value)
                  return (
                    <Badge key={value} variant="secondary" className="text-xs">
                      {option?.label}
                      <div
                        role="button"
                        tabIndex={disabled ? -1 : 0}
                        className={cn(
                          "ml-1 ring-offset-background rounded-full outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 hover:bg-destructive/20 transition-colors p-0.5",
                          disabled ? "cursor-default opacity-50" : "cursor-pointer"
                        )}
                        onKeyDown={(e) => {
                          if (e.key === "Enter" && !disabled) handleRemove(value)
                        }}
                        onMouseDown={(e) => {
                          e.preventDefault()
                          e.stopPropagation()
                        }}
                        onClick={(e) => {
                          if (!disabled) {
                            e.stopPropagation()
                            handleRemove(value)
                          }
                        }}
                      >
                        <X className="h-3 w-3 text-muted-foreground hover:text-destructive transition-colors" />
                      </div>
                    </Badge>
                  )
                })
              )}
            </div>
            <ChevronDown className="h-4 w-4 shrink-0 opacity-50" />
          </Button>
        </PopoverTrigger>
        <PopoverContent className="w-[var(--radix-popover-trigger-width)] p-0" align="start">
          <div className="max-h-[300px] overflow-y-auto p-1">
            {options.map((option, index) => (
              <div
                key={option.value}
                className={cn(
                  "relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors hover:bg-muted hover:text-foreground",
                  focusedIndex === index && "bg-accent text-accent-foreground"
                )}
                onClick={() => handleSelect(option.value)}
              >
                <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
                  <Check
                    className={cn(
                      "h-4 w-4",
                      selected.includes(option.value) ? "opacity-100" : "opacity-0"
                    )}
                  />
                </span>
                {option.label}
              </div>
            ))}
          </div>
        </PopoverContent>
      </Popover>
    </div>
  )
}