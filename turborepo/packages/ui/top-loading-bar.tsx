"use client"

import { useEffect, useState } from "react"
import { subscribeLoading } from "@repo/common/utils/loading-bus"
import { cn } from "./lib/utils"

export function TopLoadingBar() {
  const [isLoading, setIsLoading] = useState(false)
  const [show, setShow] = useState(false)

  useEffect(() => {
    return subscribeLoading(setIsLoading)
  }, [])

  useEffect(() => {
    if (isLoading) {
      setShow(true)
    } else {
      const t = setTimeout(() => setShow(false), 400)
      return () => clearTimeout(t)
    }
  }, [isLoading])

  if (!show) return null

  return (
    <>
      <style>{`
        @keyframes top-loading-bar {
          0% { transform: translateX(-100%); }
          100% { transform: translateX(350%); }
        }
      `}</style>
      <div
        className={cn(
          "fixed top-0 left-0 right-0 z-[9999] h-[3px] overflow-hidden bg-primary/20 transition-opacity duration-300",
          isLoading ? "opacity-100" : "opacity-0"
        )}
      >
        <div
          className="absolute h-full w-1/3 rounded-full bg-primary"
          style={{ animation: "top-loading-bar 1.2s ease-in-out infinite" }}
        />
      </div>
    </>
  )
}