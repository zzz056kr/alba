"use client"

import * as React from "react"
import { createContext, useCallback, useContext, useEffect, useRef, useState } from "react"
import { XIcon } from "lucide-react"
import { cn } from "./lib/utils"

interface SheetEntry {
  id: string
  title: string
  content: React.ReactNode
  level: number
  width?: number
  blockLowerSheets?: boolean
  restoreFocusTo?: HTMLElement | null
}

interface SheetStackContextType {
  sheets: SheetEntry[]
  openSheet: (sheet: { id: string; title: string; content: React.ReactNode; width?: number; blockLowerSheets?: boolean }) => void
  closeSheet: (id: string) => void
  closeTopSheet: () => void
  closeAllSheets: () => void
  blockLowerSheets: boolean
}

const SheetStackContext = createContext<SheetStackContextType | undefined>(undefined)
const EMPTY_SHEETS: SheetStackContextType['sheets'] = []
const NOOP_CLOSE_SHEET: SheetStackContextType['closeSheet'] = () => {}
const NOOP_CLOSE_TOP_SHEET: SheetStackContextType['closeTopSheet'] = () => {}

export function SmartSheetProvider({
  children,
  blockLowerSheets = true
}: {
  children: React.ReactNode
  blockLowerSheets?: boolean
}) {
  const [sheets, setSheets] = useState<SheetStackContextType['sheets']>([])

  const openSheet = useCallback((sheet: { id: string; title: string; content: React.ReactNode; width?: number; blockLowerSheets?: boolean }) => {
    const uniqueId = `${sheet.id}_${Date.now()}_${Math.random().toString(36).slice(2, 11)}`
    const restoreFocusTo = document.activeElement instanceof HTMLElement ? document.activeElement : null
    setSheets(prev => [
      ...prev,
      { ...sheet, id: uniqueId, level: prev.length, restoreFocusTo }
    ])
  }, [])

  const closeSheet = useCallback((id: string) => {
    setSheets(prev => {
      const index = prev.findIndex(s => s.id === id)
      if (index === -1) return prev
      const newSheets = prev.filter(sheet => sheet.id !== id)
      return newSheets.map((sheet, idx) => ({ ...sheet, level: idx }))
    })
  }, [])

  const closeTopSheet = useCallback(() => {
    setSheets((prev) => {
      if (prev.length === 0) return prev
      const newSheets = prev.slice(0, -1)
      return newSheets.map((sheet, idx) => ({ ...sheet, level: idx }))
    })
  }, [])

  const closeAllSheets = useCallback(() => {
    setSheets([])
  }, [])

  return (
    <SheetStackContext.Provider value={{ sheets, openSheet, closeSheet, closeTopSheet, closeAllSheets, blockLowerSheets }}>
      {children}
      <SheetStack />
    </SheetStackContext.Provider>
  )
}

function SheetStack() {
  const context = useContext(SheetStackContext)
  const sheets = context?.sheets ?? EMPTY_SHEETS
  const closeSheet = context?.closeSheet ?? NOOP_CLOSE_SHEET
  const closeTopSheet = context?.closeTopSheet ?? NOOP_CLOSE_TOP_SHEET
  const blockLowerSheets = context?.blockLowerSheets ?? true
  const [screenWidth, setScreenWidth] = useState(() => (typeof window === 'undefined' ? 1024 : window.innerWidth))
  const [enteredSheets, setEnteredSheets] = useState<Set<string>>(new Set())
  const [activeSheetId, setActiveSheetId] = useState<string | null>(null)
  const previousSheetsRef = useRef<SheetEntry[]>(sheets)
  const sheetRefs = useRef<Record<string, HTMLDivElement | null>>({})

  const getFocusableElements = useCallback((element: HTMLDivElement | null) => {
    if (!element) return [] as HTMLElement[]

    return Array.from(
      element.querySelectorAll<HTMLElement>(
        'button:not([disabled]), [href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
      )
    ).filter((node) => !node.hasAttribute('disabled') && node.getAttribute('aria-hidden') !== 'true')
  }, [])

  const isSheetBlocked = useCallback((targetIndex: number) => {
    for (let i = targetIndex + 1; i < sheets.length; i++) {
      const upperSheet = sheets[i]
      const upperBlockSetting =
        upperSheet.blockLowerSheets !== undefined ? upperSheet.blockLowerSheets : blockLowerSheets

      if (upperBlockSetting) {
        return true
      }
    }

    return false
  }, [blockLowerSheets, sheets])

  const getTopInteractiveSheetId = useCallback(() => {
    for (let i = sheets.length - 1; i >= 0; i--) {
      if (!isSheetBlocked(i)) {
        return sheets[i].id
      }
    }

    return sheets[sheets.length - 1]?.id ?? null
  }, [isSheetBlocked, sheets])

  const focusSheetById = useCallback((sheetId: string | null) => {
    if (!sheetId) {
      return
    }

    const targetSheetElement = sheetRefs.current[sheetId]
    if (!targetSheetElement) {
      return
    }

    const focusableElements = getFocusableElements(targetSheetElement)
    const nextFocusTarget = focusableElements[0] ?? targetSheetElement
    nextFocusTarget.focus()
  }, [getFocusableElements])

  useEffect(() => {
    const updateScreenWidth = () => setScreenWidth(window.innerWidth)
    updateScreenWidth()
    window.addEventListener('resize', updateScreenWidth)
    return () => window.removeEventListener('resize', updateScreenWidth)
  }, [])

  useEffect(() => {
    const frameId = window.requestAnimationFrame(() => {
      const currentSheetIds = new Set(sheets.map((sheet) => sheet.id))

      setEnteredSheets((prev) => {
        const next = new Set<string>()

        prev.forEach((id) => {
          if (currentSheetIds.has(id)) next.add(id)
        })

        sheets.forEach((sheet) => {
          next.add(sheet.id)
        })

        if (next.size === prev.size && [...next].every((id) => prev.has(id))) {
          return prev
        }

        return next
      })
    })

    return () => window.cancelAnimationFrame(frameId)
  }, [sheets])

  useEffect(() => {
    if (sheets.length === 0) {
      setActiveSheetId(null)
      return
    }

    setActiveSheetId((prev) => {
      const previousSheets = previousSheetsRef.current
      if (sheets.length > previousSheets.length) {
        return sheets[sheets.length - 1].id
      }

      if (prev) {
        const activeIndex = sheets.findIndex((sheet) => sheet.id === prev)
        if (activeIndex >= 0 && !isSheetBlocked(activeIndex)) {
          return prev
        }
      }

      const topInteractiveSheetId = getTopInteractiveSheetId()
      if (topInteractiveSheetId) {
        return topInteractiveSheetId
      }

      if (prev && sheets.some((sheet) => sheet.id === prev)) {
        return prev
      }

      return sheets[sheets.length - 1].id
    })
  }, [getTopInteractiveSheetId, isSheetBlocked, sheets])

  useEffect(() => {
    const previousSheets = previousSheetsRef.current
    const removedSheets = previousSheets.filter(
      (previousSheet) => !sheets.some((sheet) => sheet.id === previousSheet.id)
    )
    const lastRemovedSheet = removedSheets[removedSheets.length - 1]
    const topInteractiveSheetId = getTopInteractiveSheetId()

    if (topInteractiveSheetId) {
      window.requestAnimationFrame(() => {
        focusSheetById(topInteractiveSheetId)
      })
    } else if (lastRemovedSheet?.restoreFocusTo && document.contains(lastRemovedSheet.restoreFocusTo)) {
      window.requestAnimationFrame(() => {
        lastRemovedSheet.restoreFocusTo?.focus()
      })
    }

    previousSheetsRef.current = sheets
  }, [focusSheetById, getTopInteractiveSheetId, sheets])

  useEffect(() => {
    if (!activeSheetId) {
      return
    }

    const activeSheetElement = sheetRefs.current[activeSheetId]
    if (!activeSheetElement) {
      return
    }

    const focusableElements = getFocusableElements(activeSheetElement)
    const nextFocusTarget = focusableElements[0] ?? activeSheetElement

    window.requestAnimationFrame(() => {
      if (document.activeElement && activeSheetElement.contains(document.activeElement)) {
        return
      }

      nextFocusTarget.focus()
    })
  }, [activeSheetId, getFocusableElements])

  useEffect(() => {
    if (!activeSheetId) {
      return
    }

    const handleFocusIn = () => {
      const activeSheetElement = sheetRefs.current[activeSheetId]
      if (!activeSheetElement) {
        return
      }

      const currentActiveIndex = sheets.findIndex((sheet) => sheet.id === activeSheetId)
      if (currentActiveIndex < 0 || isSheetBlocked(currentActiveIndex)) {
        return
      }

      if (document.activeElement && activeSheetElement.contains(document.activeElement)) {
        return
      }

      // Radix 포털(Popover, Select, Dialog 등) 안에 포커스가 있으면 빼앗지 않음
      if (document.activeElement?.closest('[data-radix-popper-content-wrapper], [data-radix-portal]')) {
        return
      }

      focusSheetById(activeSheetId)
    }

    document.addEventListener('focusin', handleFocusIn)
    return () => document.removeEventListener('focusin', handleFocusIn)
  }, [activeSheetId, focusSheetById, isSheetBlocked, sheets])

  useEffect(() => {
    if (sheets.length === 0) {
      return
    }

    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key !== 'Escape') {
        return
      }

      const targetSheetId = activeSheetId ?? getTopInteractiveSheetId()

      if (targetSheetId) {
        closeSheet(targetSheetId)
        return
      }

      closeTopSheet()
    }

    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [activeSheetId, closeSheet, closeTopSheet, getTopInteractiveSheetId, sheets.length])

  if (!context || sheets.length === 0) return null

  const minSheetWidth = 450
  const marginBetweenSheets = 20
  const screenPadding = 40
  const availableWidth = screenWidth - screenPadding

  let maxSideBySideSheets = 0
  if (screenWidth >= 768) {
    let currentWidth = 0
    for (let i = 0; i < sheets.length; i++) {
      const sheetWidth = sheets[i].width || minSheetWidth
      const marginWidth = i > 0 ? marginBetweenSheets : 0
      if (currentWidth + marginWidth + sheetWidth <= availableWidth) {
        currentWidth += marginWidth + sheetWidth
        maxSideBySideSheets = i + 1
      } else {
        break
      }
    }
  }

  const canShowSideBySide = maxSideBySideSheets > 0

  const handleOverlayClick = () => {
    if (sheets.length > 0) {
      closeTopSheet()
    }
  }

  return (
    <>
      <div className="fixed inset-0 z-40 bg-black/50" onClick={handleOverlayClick} />
      <div className="fixed inset-0 z-50 pointer-events-none">
        {sheets.map((sheet, index) => {
          const isLastSheet = index === sheets.length - 1
          const hasEntered = enteredSheets.has(sheet.id)
          const isActive = activeSheetId === sheet.id

          let sheetStyle: React.CSSProperties = {}
          let sheetClassName = "pointer-events-auto fixed inset-y-0 bg-background shadow-lg transition-all duration-300 ease-out flex flex-col"

          const isBlocked = isSheetBlocked(index)

          if (canShowSideBySide) {
            const actualSheetWidth = sheet.width || minSheetWidth

            if (index < maxSideBySideSheets) {
              let rightPosition = screenPadding / 2
              for (let i = index + 1; i < Math.min(sheets.length, maxSideBySideSheets); i++) {
                rightPosition += (sheets[i].width || minSheetWidth) + marginBetweenSheets
              }
              sheetStyle = {
                right: `${rightPosition}px`,
                width: `${actualSheetWidth}px`,
                transform: hasEntered ? 'translateX(0)' : `translateX(${actualSheetWidth + 50}px)`,
                zIndex: 50 + index,
              }
              sheetClassName += " border-l"
            } else {
              sheetStyle = {
                right: `${screenPadding / 2}px`,
                width: `${actualSheetWidth}px`,
                transform: hasEntered ? 'translateX(0)' : `translateX(${actualSheetWidth + 50}px)`,
                zIndex: 50 + index,
              }
              sheetClassName += " border-l"
              if (!isLastSheet) sheetClassName += " brightness-90"
            }
          } else {
            const actualSheetWidth = sheet.width || minSheetWidth
            const finalWidth = screenWidth < actualSheetWidth ? screenWidth : actualSheetWidth
            sheetStyle = {
              right: screenWidth < actualSheetWidth ? '0px' : `${(screenWidth - finalWidth) / 2}px`,
              width: `${finalWidth}px`,
              transform: hasEntered ? 'translateX(0)' : `translateX(${finalWidth + 50}px)`,
              zIndex: 50 + index,
            }
            sheetClassName += " border-l"
            if (!isLastSheet) sheetClassName += " brightness-90"
          }

          return (
            <div
              key={sheet.id}
              data-sheet-id={sheet.id}
              className={sheetClassName}
              style={sheetStyle}
              ref={(element) => {
                sheetRefs.current[sheet.id] = element
              }}
              role="dialog"
              aria-modal={isLastSheet}
              aria-labelledby={`${sheet.id}-title`}
              tabIndex={-1}
              onMouseDown={() => {
                if (!isBlocked) {
                  setActiveSheetId(sheet.id)
                }
              }}
              onFocusCapture={() => {
                if (!isBlocked) {
                  setActiveSheetId(sheet.id)
                }
              }}
              onKeyDown={(event) => {
                if (!isActive || event.key !== 'Tab') {
                  return
                }

                const focusableElements = getFocusableElements(sheetRefs.current[sheet.id])
                if (focusableElements.length === 0) {
                  event.preventDefault()
                  return
                }

                const firstElement = focusableElements[0]
                const lastElement = focusableElements[focusableElements.length - 1]
                const currentElement = document.activeElement

                if (!event.shiftKey && currentElement === lastElement) {
                  event.preventDefault()
                  firstElement.focus()
                } else if (event.shiftKey && currentElement === firstElement) {
                  event.preventDefault()
                  lastElement.focus()
                }
              }}
            >
              <div className="flex items-center justify-between p-4 border-b">
                <h2 id={`${sheet.id}-title`} className="text-lg font-semibold">{sheet.title}</h2>
                <button
                  type="button"
                  onClick={() => {
                    if (!isBlocked) closeSheet(sheet.id)
                  }}
                  className={cn(
                    "p-1 rounded-sm",
                    !isBlocked
                      ? "hover:bg-muted cursor-pointer"
                      : "opacity-50 cursor-not-allowed"
                  )}
                  disabled={isBlocked}
                >
                  <XIcon className="size-4" />
                  <span className="sr-only">닫기</span>
                </button>
              </div>
              <div className={cn("flex-1 overflow-auto p-4 relative", isBlocked && "pointer-events-none")}>
                {sheet.content}
                {isBlocked && <div className="absolute inset-0 bg-background/40 z-10" />}
              </div>
            </div>
          )
        })}
      </div>
    </>
  )
}

export function useSmartSheet() {
  const context = useContext(SheetStackContext)
  if (!context) {
    throw new Error('useSmartSheet must be used within SmartSheetProvider')
  }
  return context
}
