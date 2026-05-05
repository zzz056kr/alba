'use client';

import AuthProvider from "@repo/ui/auth-provider";
import { AppSidebar } from "@/src/component/AppSidebar";
import { SiteHeader } from "@/src/component/SiteHeader";
import { SidebarInset, SidebarProvider } from "@repo/ui/sidebar";

export default function ProtectedLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <AuthProvider>
      <SidebarProvider>
        <AppSidebar />
        <SidebarInset>
          <SiteHeader />
          <main className="flex flex-1 flex-col">
            {children}
          </main>
        </SidebarInset>
      </SidebarProvider>
    </AuthProvider>
  );
}