import Link from 'next/link'

export default function NotFound() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center">
      <h1 className="text-6xl font-bold text-foreground">404</h1>
      <p className="mt-4 text-xl text-muted-foreground">페이지를 찾을 수 없습니다</p>
      <Link
        href="/"
        className="mt-6 px-4 py-2 bg-primary text-primary-foreground rounded-md hover:bg-primary/90 transition-colors"
      >
        홈으로 돌아가기
      </Link>
    </div>
  )
}