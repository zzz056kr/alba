let count = 0
const listeners = new Set<(isLoading: boolean) => void>()

function emit() {
  const isLoading = count > 0
  listeners.forEach((fn) => fn(isLoading))
}

export function startLoading(): void {
  count++
  emit()
}

export function stopLoading(): void {
  count = Math.max(0, count - 1)
  emit()
}

export function subscribeLoading(fn: (isLoading: boolean) => void): () => void {
  listeners.add(fn)
  return () => listeners.delete(fn)
}