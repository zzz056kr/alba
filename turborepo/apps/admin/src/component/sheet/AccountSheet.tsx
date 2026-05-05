'use client'

import { SheetDataLoader } from '@repo/ui/sheet-data-loader'
import { useAccountDetail } from '@/src/hooks/useAccountQueries'
import { AccountCreateForm } from './account/AccountCreateForm'
import { AccountEditForm } from './account/AccountEditForm'

interface AccountSheetProps {
  accountId?: string
  onSuccess?: () => void
}

function AccountDetailSheet({ accountId, onSuccess }: { accountId: string; onSuccess?: () => void }) {
  const { data: account, isLoading, error } = useAccountDetail(accountId)
  return (
    <SheetDataLoader isLoading={isLoading} error={error} data={account} resourceName="계정">
      {(account) => <AccountEditForm account={account} onSuccess={onSuccess} />}
    </SheetDataLoader>
  )
}

export default function AccountSheet({ accountId, onSuccess }: AccountSheetProps) {
  if (!accountId) {
    return <AccountCreateForm onSuccess={onSuccess} />
  }
  return <AccountDetailSheet accountId={accountId} onSuccess={onSuccess} />
}