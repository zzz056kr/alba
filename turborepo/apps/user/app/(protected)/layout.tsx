'use client';

import AuthProvider from "@repo/ui/auth-provider";
import { SiteHeader } from "@/src/component/SiteHeader";

export default function ProtectedLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <AuthProvider>
      <div className="flex min-h-screen flex-col">
        <SiteHeader />
        <main className="flex flex-1 flex-col">
          {children}
        </main>
      </div>
    </AuthProvider>
  );
}
