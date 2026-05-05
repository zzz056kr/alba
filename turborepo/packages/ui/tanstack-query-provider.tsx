"use client";

import { MutationCache, QueryCache, QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { type ReactNode, useState } from "react";
import { toast } from "sonner";

function isAxiosError(error: unknown): boolean {
  return !!(error && typeof error === 'object' && 'isAxiosError' in error)
}

function extractErrorMessage(error: unknown): string {
  if (error && typeof error === 'object') {
    const e = error as { message?: string }
    return e.message || '요청 처리 중 오류가 발생했습니다.'
  }
  return '요청 처리 중 오류가 발생했습니다.'
}

export default function TanstackQueryProvider({ children }: { children: ReactNode }) {
  const [queryClient] = useState(
    () =>
      new QueryClient({
        queryCache: new QueryCache({
          onError: (error) => {
            if (!isAxiosError(error)) {
              toast.error(extractErrorMessage(error))
            }
          },
        }),
        mutationCache: new MutationCache({
          onError: (error) => {
            if (!isAxiosError(error)) {
              toast.error(extractErrorMessage(error))
            }
          },
        }),
        defaultOptions: {
          queries: {
            refetchOnWindowFocus: false,
            retry: false,
          },
        },
      }),
  );

  return <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>;
}