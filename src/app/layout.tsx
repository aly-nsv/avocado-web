import type { Metadata } from 'next'
import './globals.css'
import { Shield, Home, BarChart3, Settings, Users, Lock, Bell, Search } from 'lucide-react'
import {
  Button,
  Input,
  SearchInput,
  Heading,
  Text,
  Link,
  StatusBadge,
} from '@/components/ui'

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
        <div className="min-h-screen bg-background">
          {/* Header */}
          <header className="border-b border-neutral-700 bg-surface/50 backdrop-blur">
            <div className="container mx-auto px-6 py-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-4">
                  <Shield className="h-8 w-8 text-primary-400" />
                  <Heading variant="h3" className="text-neutral-100">
                    Security Dashboard
                  </Heading>
                </div>
                <div className="flex items-center space-x-4">
                  <StatusBadge status="online">System Operational</StatusBadge>
                  <Button variant="outline" size="sm">
                    <Bell className="h-4 w-4 mr-2" />
                    Alerts
                  </Button>
                  <Button variant="outline" size="sm">
                    Settings
                  </Button>
                </div>
              </div>
            </div>
            
            {/* Navigation Bar */}
            <nav className="border-t border-neutral-700/50 bg-surface/30">
              <div className="container mx-auto px-6">
                <div className="flex items-center justify-between py-3">
                  <div className="flex items-center space-x-6">
                    <Link href="/" className="flex items-center space-x-2 text-primary-300 hover:text-primary-200 transition-colors">
                      <Home className="h-4 w-4" />
                      <span>Dashboard</span>
                    </Link>
                    <Link href="/analytics" className="flex items-center space-x-2 text-neutral-300 hover:text-neutral-100 transition-colors">
                      <BarChart3 className="h-4 w-4" />
                      <span>Analytics</span>
                    </Link>
                    <Link href="/users" className="flex items-center space-x-2 text-neutral-300 hover:text-neutral-100 transition-colors">
                      <Users className="h-4 w-4" />
                      <span>Users</span>
                    </Link>
                    <Link href="/security" className="flex items-center space-x-2 text-neutral-300 hover:text-neutral-100 transition-colors">
                      <Lock className="h-4 w-4" />
                      <span>Security</span>
                    </Link>
                    <Link href="/design-suite" className="flex items-center space-x-2 text-neutral-300 hover:text-neutral-100 transition-colors">
                      <Settings className="h-4 w-4" />
                      <span>Design Suite</span>
                    </Link>
                  </div>
                  <div className="flex items-center space-x-4">
                    <SearchInput 
                      placeholder="Search logs, users, alerts..." 
                      size="sm"
                      className="w-64"
                    />
                  </div>
                </div>
              </div>
            </nav>
          </header>

          {/* Main Content */}
          <main className="container mx-auto px-6 py-8">
            {children}
          </main>

          {/* Footer */}
          <footer className="border-t border-neutral-700 bg-surface/30 backdrop-blur mt-16">
            <div className="container mx-auto px-6 py-12">
              <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
                <div className="space-y-4">
                  <div className="flex items-center space-x-2">
                    <Shield className="h-6 w-6 text-primary-400" />
                    <Heading variant="h5" className="text-neutral-100">
                      Security Dashboard
                    </Heading>
                  </div>
                  <Text variant="body2" className="text-neutral-400">
                    Advanced security monitoring and threat detection platform for modern enterprises.
                  </Text>
                </div>
                
                <div className="space-y-4">
                  <Heading variant="h6" className="text-neutral-200">
                    Platform
                  </Heading>
                  <div className="space-y-2">
                    <Link href="/dashboard" variant="muted">Dashboard</Link>
                    <Link href="/analytics" variant="muted">Analytics</Link>
                    <Link href="/monitoring" variant="muted">Monitoring</Link>
                    <Link href="/alerts" variant="muted">Alerts</Link>
                  </div>
                </div>
                
                <div className="space-y-4">
                  <Heading variant="h6" className="text-neutral-200">
                    Security
                  </Heading>
                  <div className="space-y-2">
                    <Link href="/threat-detection" variant="muted">Threat Detection</Link>
                    <Link href="/vulnerability-management" variant="muted">Vulnerability Management</Link>
                    <Link href="/incident-response" variant="muted">Incident Response</Link>
                    <Link href="/compliance" variant="muted">Compliance</Link>
                  </div>
                </div>
                
                <div className="space-y-4">
                  <Heading variant="h6" className="text-neutral-200">
                    Support
                  </Heading>
                  <div className="space-y-2">
                    <Link href="/docs" variant="muted">Documentation</Link>
                    <Link href="/api" variant="muted">API Reference</Link>
                    <Link href="/support" variant="muted">Support</Link>
                    <Link href="/contact" variant="muted">Contact</Link>
                  </div>
                </div>
              </div>
              
              <div className="border-t border-neutral-700 mt-8 pt-8">
                <div className="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
                  <Text variant="caption" className="text-neutral-400">
                    © 2024 Security Dashboard. Built with Next.js, TypeScript, and Tailwind CSS.
                  </Text>
                  <div className="flex items-center space-x-6">
                    <Link href="/privacy" variant="muted" className="text-sm">Privacy Policy</Link>
                    <Link href="/terms" variant="muted" className="text-sm">Terms of Service</Link>
                    <Link href="/security" variant="muted" className="text-sm">Security</Link>
                  </div>
                </div>
              </div>
            </div>
          </footer>
        </div>
      </body>
    </html>
  )
}