'use client'

import { useRouter } from 'next/navigation'
import { Button } from '@repo/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@repo/ui/card'

export default function Home() {
  const router = useRouter()

  return (
    <div className="mx-auto flex w-full max-w-6xl flex-1 items-center px-4 py-8">
      <Card className="w-full">
        <CardHeader>
          <CardTitle>메인 페이지</CardTitle>
          <CardDescription>내 정보에서 계정 정보 확인과 비밀번호 변경을 진행할 수 있습니다.</CardDescription>
        </CardHeader>
        <CardContent>
          <Button onClick={() => router.push('/my/profile')}>내 정보로 이동</Button>
        </CardContent>
      </Card>
    </div>
  )
}
