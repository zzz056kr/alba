export type BadgeVariant = 'default' | 'secondary' | 'destructive' | 'outline' | 'ghost' | 'link'

export function toBadgeVariant(variant?: string): BadgeVariant {
  if (
    variant === 'default' ||
    variant === 'secondary' ||
    variant === 'destructive' ||
    variant === 'outline' ||
    variant === 'ghost' ||
    variant === 'link'
  ) {
    return variant
  }

  return 'outline'
}