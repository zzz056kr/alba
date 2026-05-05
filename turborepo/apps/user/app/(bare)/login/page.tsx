import { Suspense } from "react";
import LoginPage from "@/src/page/login/LoginPage";

export default function LoginPageApp() {
  return (
    <Suspense fallback={null}>
      <LoginPage />
    </Suspense>
  )
}