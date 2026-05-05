'use client'

import { Edit3, Loader2, X } from 'lucide-react'
import { Button } from '../button'

interface FormActionsProps {
  isEditing: boolean
  isPending?: boolean
  onEdit?: () => void
  onCancel?: () => void
  editLabel?: string
  saveLabel?: string
}

export function FormActions({
  isEditing,
  isPending = false,
  onEdit,
  onCancel,
  editLabel = '수정',
  saveLabel = '저장',
}: FormActionsProps) {
  return (
    <div className="flex justify-end gap-2 pt-4">
      {isEditing ? (
        <>
          {onCancel && (
            <Button type="button" variant="outline" onClick={onCancel}>
              <X className="h-4 w-4 mr-2" />
              취소
            </Button>
          )}
          <Button type="submit" disabled={isPending}>
            {isPending && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
            {saveLabel}
          </Button>
        </>
      ) : (
        onEdit && (
          <Button type="button" variant="outline" onClick={onEdit}>
            <Edit3 className="h-4 w-4 mr-2" />
            {editLabel}
          </Button>
        )
      )}
    </div>
  )
}