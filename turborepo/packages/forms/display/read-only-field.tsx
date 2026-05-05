import { Label } from '@repo/ui/label'

export function ReadOnlyField({ label, value }: { label: string; value?: string | null }) {
  return (
    <div className="space-y-1">
      <Label className="text-xs text-muted-foreground">{label}</Label>
      <div className="px-3 py-2 rounded-md bg-muted/40 text-sm min-h-9 flex items-center">
        {value ?? '-'}
      </div>
    </div>
  )
}
