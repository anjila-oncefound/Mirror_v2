import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Mirror — Research Network",
  description: "Mirror Research Network Platform",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}
