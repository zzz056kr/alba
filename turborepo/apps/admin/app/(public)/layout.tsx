import {SiteHeader} from "@/src/component/SiteHeader";

export default function PublicLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex min-h-screen flex-col">
      <SiteHeader />
      <main className="flex flex-1 flex-col">
        {children}
      </main>
    </div>
  );
}