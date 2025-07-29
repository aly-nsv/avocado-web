import type { Metadata } from 'next'
import './globals.css'
import { StateMapProvider } from '@/components/providers/StateMapProvider'

export const metadata: Metadata = {
  title: 'AVocado Smart Road Dashboard',
  description: 'Real-time transportation intelligence platform',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" className="dark">
      <body className="bg-background text-neutral-100 antialiased">
        <StateMapProvider>
          {children}
        </StateMapProvider>
      </body>
    </html>
  )
}