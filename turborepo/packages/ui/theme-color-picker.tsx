"use client"

import * as React from "react"
import { Palette } from "lucide-react"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectSeparator,
  SelectTrigger,
  SelectValue,
} from "./select"

const THEME_PRESETS = [
  // Minimal - 깔끔한 무채색
  { value: "default", group: "minimal", primary: { light: "oklch(0.25 0 0)", dark: "oklch(0.9 0 0)" }, secondary: { light: "oklch(0.95 0 0)", dark: "oklch(0.2 0 0)" } },
  { value: "slate", group: "minimal", primary: { light: "oklch(0.35 0.03 250)", dark: "oklch(0.75 0.03 250)" }, secondary: { light: "oklch(0.92 0.01 250)", dark: "oklch(0.22 0.02 250)" } },
  // Vivid - 선명한 단색
  { value: "blue", group: "vivid", primary: { light: "oklch(0.55 0.25 250)", dark: "oklch(0.7 0.2 250)" }, secondary: { light: "oklch(0.92 0.06 250)", dark: "oklch(0.28 0.08 250)" } },
  { value: "red", group: "vivid", primary: { light: "oklch(0.55 0.25 25)", dark: "oklch(0.68 0.22 25)" }, secondary: { light: "oklch(0.95 0.05 25)", dark: "oklch(0.28 0.08 25)" } },
  { value: "green", group: "vivid", primary: { light: "oklch(0.55 0.2 145)", dark: "oklch(0.7 0.18 145)" }, secondary: { light: "oklch(0.93 0.05 145)", dark: "oklch(0.25 0.06 145)" } },
  { value: "purple", group: "vivid", primary: { light: "oklch(0.5 0.25 300)", dark: "oklch(0.68 0.22 300)" }, secondary: { light: "oklch(0.93 0.06 300)", dark: "oklch(0.25 0.08 300)" } },
  { value: "orange", group: "vivid", primary: { light: "oklch(0.65 0.22 50)", dark: "oklch(0.75 0.2 50)" }, secondary: { light: "oklch(0.95 0.05 50)", dark: "oklch(0.28 0.06 50)" } },
  // Contrast - 대비가 강한 조합
  { value: "ocean", group: "contrast", primary: { light: "oklch(0.45 0.2 240)", dark: "oklch(0.65 0.18 240)" }, secondary: { light: "oklch(0.85 0.12 180)", dark: "oklch(0.35 0.1 180)" } },
  { value: "sunset", group: "contrast", primary: { light: "oklch(0.55 0.25 30)", dark: "oklch(0.7 0.22 30)" }, secondary: { light: "oklch(0.88 0.15 60)", dark: "oklch(0.35 0.12 60)" } },
  { value: "forest", group: "contrast", primary: { light: "oklch(0.45 0.18 150)", dark: "oklch(0.6 0.15 150)" }, secondary: { light: "oklch(0.88 0.1 90)", dark: "oklch(0.32 0.08 90)" } },
  { value: "berry", group: "contrast", primary: { light: "oklch(0.5 0.25 320)", dark: "oklch(0.68 0.22 320)" }, secondary: { light: "oklch(0.85 0.12 280)", dark: "oklch(0.3 0.1 280)" } },
  // Pastel - 파스텔 톤
  { value: "sky", group: "pastel", primary: { light: "oklch(0.7 0.12 220)", dark: "oklch(0.75 0.1 220)" }, secondary: { light: "oklch(0.95 0.04 220)", dark: "oklch(0.3 0.05 220)" } },
  { value: "mint", group: "pastel", primary: { light: "oklch(0.75 0.1 170)", dark: "oklch(0.7 0.12 170)" }, secondary: { light: "oklch(0.95 0.03 170)", dark: "oklch(0.28 0.05 170)" } },
  { value: "peach", group: "pastel", primary: { light: "oklch(0.75 0.12 40)", dark: "oklch(0.78 0.1 40)" }, secondary: { light: "oklch(0.96 0.04 40)", dark: "oklch(0.3 0.05 40)" } },
  { value: "lavender", group: "pastel", primary: { light: "oklch(0.7 0.12 290)", dark: "oklch(0.72 0.1 290)" }, secondary: { light: "oklch(0.95 0.04 290)", dark: "oklch(0.28 0.05 290)" } },
  // Bold - 강렬한 조합
  { value: "neon", group: "bold", primary: { light: "oklch(0.7 0.3 150)", dark: "oklch(0.8 0.28 150)" }, secondary: { light: "oklch(0.6 0.25 320)", dark: "oklch(0.45 0.2 320)" } },
  { value: "cyber", group: "bold", primary: { light: "oklch(0.6 0.28 280)", dark: "oklch(0.75 0.25 280)" }, secondary: { light: "oklch(0.65 0.22 200)", dark: "oklch(0.4 0.18 200)" } },
  { value: "fire", group: "bold", primary: { light: "oklch(0.6 0.28 30)", dark: "oklch(0.72 0.25 30)" }, secondary: { light: "oklch(0.7 0.2 60)", dark: "oklch(0.4 0.15 60)" } },
]

const GROUPS = ["minimal", "vivid", "contrast", "pastel", "bold"]
const STORAGE_KEY = "theme-color"

function getForeground(preset: typeof THEME_PRESETS[0], isDark: boolean, isPrimary: boolean): string {
  const isDefault = preset.group === "minimal" && preset.value === "default"
  if (isDefault) {
    if (isPrimary) return isDark ? "oklch(0.15 0 0)" : "oklch(0.98 0 0)"
    return isDark ? "oklch(0.95 0 0)" : "oklch(0.15 0 0)"
  }
  if (isPrimary) return isDark ? "oklch(0.12 0 0)" : "oklch(0.98 0 0)"
  return isDark ? "oklch(0.95 0 0)" : "oklch(0.12 0 0)"
}

function buildThemeVars(value: string, dark: boolean): Record<string, string> {
  const preset = THEME_PRESETS.find(p => p.value === value) ?? THEME_PRESETS[0]
  const primary = dark ? preset.primary.dark : preset.primary.light
  const secondary = dark ? preset.secondary.dark : preset.secondary.light
  const primaryFg = getForeground(preset, dark, true)
  const secondaryFg = getForeground(preset, dark, false)
  return {
    "--primary": primary,
    "--primary-foreground": primaryFg,
    "--color-primary": primary,
    "--color-primary-foreground": primaryFg,
    "--secondary": secondary,
    "--secondary-foreground": secondaryFg,
    "--color-secondary": secondary,
    "--color-secondary-foreground": secondaryFg,
    "--sidebar-primary": primary,
    "--sidebar-primary-foreground": primaryFg,
    "--color-sidebar-primary": primary,
    "--color-sidebar-primary-foreground": primaryFg,
  }
}

function applyTheme(value: string) {
  const root = document.documentElement
  const isDark = root.classList.contains("dark")
  const vars = buildThemeVars(value, isDark)
  Object.entries(vars).forEach(([k, v]) => root.style.setProperty(k, v))

  try {
    localStorage.setItem("theme-color-vars", JSON.stringify({
      light: buildThemeVars(value, false),
      dark: buildThemeVars(value, true),
    }))
  } catch { /* ignore */ }
}

export function ThemeColorPicker() {
  const [mounted, setMounted] = React.useState(false)
  const [theme, setTheme] = React.useState("default")
  const [isDark, setIsDark] = React.useState(false)

  React.useEffect(() => {
    setMounted(true)
    const saved = localStorage.getItem(STORAGE_KEY) ?? "default"
    setTheme(saved)
    setIsDark(document.documentElement.classList.contains("dark"))
    applyTheme(saved)
  }, [])

  React.useEffect(() => {
    if (!mounted) return
    const observer = new MutationObserver(() => {
      setIsDark(document.documentElement.classList.contains("dark"))
      applyTheme(theme)
    })
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ["class"] })
    return () => observer.disconnect()
  }, [mounted, theme])

  const handleChange = (value: string) => {
    setTheme(value)
    localStorage.setItem(STORAGE_KEY, value)
    applyTheme(value)
  }

  if (!mounted) {
    return (
      <div className="flex items-center gap-1">
        <Palette className="h-4 w-4 text-muted-foreground" />
        <div className="h-8 w-24 bg-muted rounded animate-pulse" />
      </div>
    )
  }

  const currentPreset = THEME_PRESETS.find(p => p.value === theme)
  const primaryColor = isDark ? currentPreset?.primary.dark : currentPreset?.primary.light
  const secondaryColor = isDark ? currentPreset?.secondary.dark : currentPreset?.secondary.light

  return (
    <div className="flex items-center gap-1">
      <Palette className="h-4 w-4 text-muted-foreground" />
      <Select value={theme} onValueChange={handleChange}>
        <SelectTrigger className="w-auto h-8 text-xs gap-1.5 px-2">
          <SelectValue placeholder="Theme">
            <div className="flex items-center gap-1">
              <div className="w-3 h-3 rounded-full border shrink-0" style={{ backgroundColor: primaryColor }} />
              <div className="w-3 h-3 rounded-full border shrink-0" style={{ backgroundColor: secondaryColor }} />
            </div>
          </SelectValue>
        </SelectTrigger>
        <SelectContent>
          {GROUPS.map((group, groupIndex) => (
            <React.Fragment key={group}>
              {groupIndex > 0 && <SelectSeparator />}
              {THEME_PRESETS.filter(p => p.group === group).map((preset) => (
                <SelectItem key={preset.value} value={preset.value}>
                  <div className="flex items-center gap-1.5">
                    <div className="w-3 h-3 rounded-full border shrink-0" style={{ backgroundColor: preset.primary.light }} />
                    <div className="w-3 h-3 rounded-full border shrink-0" style={{ backgroundColor: preset.secondary.light }} />
                    <span className="text-xs">{preset.value}</span>
                  </div>
                </SelectItem>
              ))}
            </React.Fragment>
          ))}
        </SelectContent>
      </Select>
    </div>
  )
}