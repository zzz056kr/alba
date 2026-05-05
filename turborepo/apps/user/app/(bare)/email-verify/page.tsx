import { Suspense } from 'react'
import EmailVerifyPage from '@/src/page/email-verify/EmailVerifyPage'

export default function EmailVerifyPageApp() {
  return (
    <Suspense fallback={null}>
      <EmailVerifyPage />
    </Suspense>
  )
}