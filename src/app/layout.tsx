import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Security Dashboard',
  description: 'A modern security operations dashboard',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" className="dark">
      <body className="bg-background text-neutral-100 antialiased">
        {children}
      </body>
    </html>
  )
}