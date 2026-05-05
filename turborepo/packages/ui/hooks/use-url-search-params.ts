import { useRouter, useSearchParams } from 'next/navigation'
import { useCallback, useEffect, useRef, useState } from 'react'

interface UseUrlSearchParamsOptions<T> {
  defaultValues: T
  serialize: (values: T) => Record<string, string>
  deserialize: (params: URLSearchParams) => T
  manualSearch?: boolean
}

// 수동 검색 모드
interface ManualSearchReturn<T> {
  appliedValues: T
  tempValues: T
  updateTempValues: (newValues: Partial<T> | ((prev: T) => T)) => void
  updateAppliedValues: (newValues: Partial<T> | ((prev: T) => T)) => void
  applySearch: (overrides?: Partial<T>) => void
  reset: () => void
  isInitialized: boolean
}

// 자동 검색 모드
interface AutoSearchReturn<T> {
  values: T
  updateValues: (newValues: Partial<T> | ((prev: T) => T)) => void
  resetValues: () => void
  isInitialized: boolean
}

export function useUrlSearchParams<T>(options: UseUrlSearchParamsOptions<T> & { manualSearch: true }): ManualSearchReturn<T>
export function useUrlSearchParams<T>(options: UseUrlSearchParamsOptions<T> & { manualSearch?: false }): AutoSearchReturn<T>
export function useUrlSearchParams<T>({
  defaultValues,
  serialize,
  deserialize,
  manualSearch = false
}: UseUrlSearchParamsOptions<T>): ManualSearchReturn<T> | AutoSearchReturn<T> {
  const router = useRouter()
  const searchParams = useSearchParams()

  const [appliedValues, setAppliedValues] = useState<T>(() => {
    try {
      return deserialize(searchParams)
    } catch {
      return defaultValues
    }
  })

  const [tempValues, setTempValues] = useState<T>(appliedValues)
  const tempValuesRef = useRef<T>(tempValues)

  useEffect(() => {
    tempValuesRef.current = tempValues
  }, [tempValues])

  const [isInitialized, setIsInitialized] = useState(false)

  useEffect(() => {
    if (!isInitialized) {
      setIsInitialized(true)
      return
    }

    try {
      const newValues = deserialize(searchParams)
      setAppliedValues(newValues)
      setTempValues(newValues)
    } catch {
      setAppliedValues(defaultValues)
      setTempValues(defaultValues)
    }
  }, [searchParams, deserialize, defaultValues, isInitialized, manualSearch])

  const updateUrl = useCallback((newValues: T) => {
    const serialized = serialize(newValues)
    const urlParams = new URLSearchParams()

    Object.entries(serialized).forEach(([key, value]) => {
      if (value && value.trim() !== '') {
        urlParams.set(key, value)
      }
    })

    const newUrl = urlParams.toString() ? `?${urlParams.toString()}` : window.location.pathname
    router.push(newUrl, { scroll: false })
  }, [router, serialize])

  const updateTempValues = useCallback((newValues: Partial<T> | ((prev: T) => T)) => {
    setTempValues(prev => {
      return typeof newValues === 'function'
        ? newValues(prev)
        : { ...prev, ...newValues }
    })
  }, [])

  const updateAppliedValues = useCallback((newValues: Partial<T> | ((prev: T) => T)) => {
    setAppliedValues(prev => {
      const updated = typeof newValues === 'function'
        ? newValues(prev)
        : { ...prev, ...newValues }

      if (isInitialized) {
        updateUrl(updated)
      }

      return updated
    })
  }, [updateUrl, isInitialized])

  const applySearch = useCallback((overrides?: Partial<T>) => {
    const currentTempValues = overrides
      ? { ...tempValuesRef.current, ...overrides }
      : tempValuesRef.current
    setTempValues(currentTempValues)
    setAppliedValues(currentTempValues)
    if (isInitialized) {
      updateUrl(currentTempValues)
    }
  }, [updateUrl, isInitialized])

  const reset = useCallback(() => {
    setAppliedValues(defaultValues)
    setTempValues(defaultValues)
    if (isInitialized) {
      updateUrl(defaultValues)
    }
  }, [defaultValues, updateUrl, isInitialized])

  if (manualSearch) {
    return {
      appliedValues,
      tempValues,
      updateTempValues,
      updateAppliedValues,
      applySearch,
      reset,
      isInitialized
    }
  } else {
    return {
      values: appliedValues,
      updateValues: updateAppliedValues,
      resetValues: reset,
      isInitialized
    }
  }
}