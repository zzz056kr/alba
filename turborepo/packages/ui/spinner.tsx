export default function Spinner() {
  return (
    <div className="min-h-screen flex items-center justify-center" role="status" aria-label="로딩 중">
      <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
    </div>
  )
}