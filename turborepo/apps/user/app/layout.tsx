import type { Metadata } from "next";
import "./globals.css";
import TanstackQueryProvider from "@repo/ui/tanstack-query-provider";
import AxiosInitializer from "@/src/common/AxiosInitializer";
import { Toaster } from "@repo/ui/sonner";
import { TooltipProvider } from "@repo/ui/tooltip";
import { TopLoadingBar } from "@repo/ui/top-loading-bar";
import AuthInitializer from "@repo/ui/auth-initializer";

export const metadata: Metadata = {
  title: "User",
  description: "User app",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ko" suppressHydrationWarning>
      <head>
        <script dangerouslySetInnerHTML={{ __html: `try{var t=localStorage.getItem('theme');if(!t)t=window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light';document.documentElement.classList.add(t)}catch(e){}` }} />
        <script dangerouslySetInnerHTML={{ __html: `try{var cv=JSON.parse(localStorage.getItem('theme-color-vars')||'null');if(cv){var isDark=document.documentElement.classList.contains('dark');var v=isDark?cv.dark:cv.light;var r=document.documentElement;Object.keys(v).forEach(function(k){r.style.setProperty(k,v[k])})}}catch(e){}` }} />
        <script dangerouslySetInnerHTML={{ __html: `try{var fs=localStorage.getItem('font-size');if(fs)document.documentElement.style.fontSize=fs+'px'}catch(e){}` }} />
      </head>
      <body className="antialiased" suppressHydrationWarning={true}>
        <TopLoadingBar />
        <AxiosInitializer />
        <TanstackQueryProvider>
          <AuthInitializer>
            <TooltipProvider>
              {children}
              <Toaster />
            </TooltipProvider>
          </AuthInitializer>
        </TanstackQueryProvider>
      </body>
    </html>
  );
}