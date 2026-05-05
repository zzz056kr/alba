'use client';

import { useAuthStore } from "@repo/api-client/store/auth-store";
import { SiteHeader } from "@/src/component/SiteHeader";

export default function PublicLayout({
                                       children,
                                     }: {
  children: React.ReactNode;
}) {
  const initStatus = useAuthStore((s) => s.initStatus);
  const authPending = initStatus === 'pending';

  return (
    <div className="flex min-h-screen flex-col">
      <SiteHeader />
      <main
        className="flex flex-1 flex-col"
        inert={authPending}
        aria-busy={authPending}
      >
        {children}
      </main>
    </div>
  );
}