import React, { useState, useEffect, useRef, useCallback } from 'react'
import { Check, ChevronDown, Loader2 } from 'lucide-react'
import { cn } from "./lib/utils"
import { Button } from './button'
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from './command'
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from './popover'

interface SearchableSelectOption {
  value: string | number
  label: string
  sublabel?: string
}

export interface SearchableSelectProps {
  value?: string | number
  onValueChange: (value: string | number | undefined) => void
  options: SearchableSelectOption[]
  onSearch?: (keyword: string) => void
  placeholder?: string
  emptyMessage?: string
  className?: string
  disabled?: boolean
  hasNextPage?: boolean
  onLoadMore?: () => void
  isLoadingMore?: boolean
}

export function SearchableSelect({
  value,
  onValueChange,
  options,
  onSearch,
  placeholder = "항목 선택...",
  emptyMessage = "검색 결과가 없습니다.",
  className,
  disabled = false,
  hasNextPage = false,
  onLoadMore,
  isLoadingMore = false,
}: SearchableSelectProps) {
  const [open, setOpen] = useState(false)
  const [searchKeyword, setSearchKeyword] = useState('')
  const listRef = useRef<HTMLDivElement>(null)

  const selectedOption = options.find((option) => String(option.value) === String(value))

  const isServerSearch = !!onSearch

  useEffect(() => {
    if (onSearch) {
      onSearch(searchKeyword)
    }
  }, [searchKeyword, onSearch])

  const handleScroll = useCallback((e: React.UIEvent<HTMLDivElement>) => {
    const { scrollTop, scrollHeight, clientHeight } = e.currentTarget
    if (scrollHeight - scrollTop <= clientHeight * 1.5 && hasNextPage && !isLoadingMore && onLoadMore) {
      onLoadMore()
    }
  }, [hasNextPage, isLoadingMore, onLoadMore])

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          role="combobox"
          aria-expanded={open}
          className={cn("h-10 w-full justify-between text-left text-sm", className)}
          disabled={disabled}
        >
          {selectedOption ? (
            <div className="flex flex-col items-start min-w-0 flex-1">
              <span className="truncate w-full">{selectedOption.label}</span>
              {selectedOption.sublabel && (
                <span className="text-xs text-muted-foreground truncate w-full">{selectedOption.sublabel}</span>
              )}
            </div>
          ) : (
            <span className="truncate text-muted-foreground">{placeholder}</span>
          )}
          <ChevronDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-[var(--radix-popover-trigger-width)] min-w-[8rem] p-0" align="start">
        <Command shouldFilter={!isServerSearch}>
          <CommandInput
            placeholder="검색..."
            value={searchKeyword}
            onValueChange={setSearchKeyword}
          />
          <CommandList ref={listRef} onScroll={handleScroll}>
            <CommandEmpty>{emptyMessage}</CommandEmpty>
            <CommandGroup>
              {/* "전체" 옵션 */}
              <CommandItem
                onSelect={() => {
                  onValueChange(undefined)
                  setOpen(false)
                }}
              >
                <Check
                  className={cn(
                    "mr-2 h-4 w-4",
                    !value ? "opacity-100" : "opacity-0"
                  )}
                />
                전체
              </CommandItem>
              {options.map((option) => (
                <CommandItem
                  key={option.value}
                  value={`${option.label} ${option.sublabel ?? ''} ${option.value}`}
                  onSelect={() => {
                    onValueChange(option.value)
                    setOpen(false)
                  }}
                >
                  <Check
                    className={cn(
                      "mr-2 h-4 w-4",
                      String(value) === String(option.value) ? "opacity-100" : "opacity-0"
                    )}
                  />
                  <div className="flex flex-col items-start min-w-0 flex-1">
                    <span className="truncate w-full">{option.label}</span>
                    {option.sublabel && (
                      <span className="text-xs text-muted-foreground truncate w-full">
                        {option.sublabel}
                      </span>
                    )}
                  </div>
                </CommandItem>
              ))}
              {/* 로딩 인디케이터 */}
              {isLoadingMore && (
                <CommandItem disabled>
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                  더 불러오는 중...
                </CommandItem>
              )}
            </CommandGroup>
          </CommandList>
        </Command>
      </PopoverContent>
    </Popover>
  )
}