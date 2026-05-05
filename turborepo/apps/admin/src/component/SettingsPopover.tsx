'use client'

import { Settings2 } from 'lucide-react'
import { Button } from '@repo/ui/button'
import { Popover, PopoverContent, PopoverTrigger } from '@repo/ui/popover'
import { FontSizeControl } from '@repo/ui/font-size-control'
import { ThemeColorPicker } from '@repo/ui/theme-color-picker'

export function SettingsPopover() {
  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button variant="ghost" size="icon" title="설정">
          <Settings2 className="h-4 w-4" />
        </Button>
      </PopoverTrigger>
      <PopoverContent align="end" className="w-auto">
        <div className="flex flex-col gap-4">
          <div className="flex flex-col gap-2">
            <p className="text-xs font-medium text-muted-foreground">글자 크기</p>
            <FontSizeControl />
          </div>
          <div className="flex flex-col gap-2">
            <p className="text-xs font-medium text-muted-foreground">테마 색상</p>
            <ThemeColorPicker />
          </div>
        </div>
      </PopoverContent>
    </Popover>
  )
}