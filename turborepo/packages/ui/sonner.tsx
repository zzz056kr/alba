'use client'

import * as React from "react"
import {
  CircleCheckIcon,
  InfoIcon,
  Loader2Icon,
  OctagonXIcon,
  TriangleAlertIcon,
} from "lucide-react"
import { Toaster as SonnerToaster } from "sonner"

const Toaster = () => {
  return React.createElement(
    SonnerToaster as React.ElementType,
    {
      theme: "system",
      className: "toaster group",
      icons: {
        success: <CircleCheckIcon className="size-4" />,
        info: <InfoIcon className="size-4" />,
        warning: <TriangleAlertIcon className="size-4" />,
        error: <OctagonXIcon className="size-4" />,
        loading: <Loader2Icon className="size-4 animate-spin" />,
      },
      toastOptions: {
        classNames: {
          error: '!bg-destructive !text-white !border-destructive',
          success: '!bg-background !text-foreground !border-border',
          warning: '!bg-background !text-foreground !border-border',
          info: '!bg-background !text-foreground !border-border',
        },
      },
      style: {
        "--border-radius": "var(--radius)",
      } as React.CSSProperties,
    }
  )
}

export { Toaster }
