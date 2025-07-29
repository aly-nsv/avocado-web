'use client'

import { Shield, Activity, AlertTriangle, Users, Server, Lock } from 'lucide-react'
import {
  Button,
  Input,
  PasswordInput,
  SearchInput,
  Card,
  CardHeader,
  CardFooter,
  CardTitle,
  CardDescription,
  CardContent,
  Heading,
  Text,
  Link,
  Code,
  Badge,
  StatusBadge,
  Tag
} from '@/components/ui'

export default function HomePage() {
  return (
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
                Settings
              </Button>
            </div>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-6 py-8">
        {/* Hero Section */}
        <section className="mb-12">
          <Card variant="gradient" size="lg" className="text-center">
            <CardContent>
              <Heading variant="h1" className="mb-4">
                Component Library Demo
              </Heading>
              <Text variant="subtitle1" className="mb-6 text-neutral-200">
                A comprehensive security dashboard built with Next.js, TypeScript, and Tailwind CSS
              </Text>
              <div className="flex flex-wrap justify-center gap-4">
                <Button size="lg" leftIcon={<Shield className="h-5 w-5" />}>
                  Start Monitoring
                </Button>
                <Button variant="outline" size="lg">
                  View Analytics
                </Button>
              </div>
            </CardContent>
          </Card>
        </section>

        {/* Buttons Section */}
        <section className="mb-12">
          <Heading variant="h2" className="mb-6">
            Buttons
          </Heading>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Card>
              <CardHeader>
                <CardTitle>Button Variants</CardTitle>
                <CardDescription>Different button styles for various use cases</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex flex-wrap gap-2">
                  <Button variant="primary">Primary</Button>
                  <Button variant="secondary">Secondary</Button>
                  <Button variant="outline">Outline</Button>
                  <Button variant="ghost">Ghost</Button>
                  <Button variant="link">Link</Button>
                </div>
                <div className="flex flex-wrap gap-2">
                  <Button variant="danger">Danger</Button>
                  <Button variant="success">Success</Button>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Button Sizes</CardTitle>
                <CardDescription>Various button sizes for different contexts</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex flex-wrap items-center gap-2">
                  <Button size="xs">Extra Small</Button>
                  <Button size="sm">Small</Button>
                  <Button size="md">Medium</Button>
                  <Button size="lg">Large</Button>
                  <Button size="xl">Extra Large</Button>
                </div>
                <div className="flex gap-2">
                  <Button size="icon"><Lock className="h-4 w-4" /></Button>
                  <Button loading>Loading</Button>
                  <Button disabled>Disabled</Button>
                </div>
              </CardContent>
            </Card>
          </div>
        </section>

        {/* Inputs Section */}
        <section className="mb-12">
          <Heading variant="h2" className="mb-6">
            Form Inputs
          </Heading>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Card>
              <CardHeader>
                <CardTitle>Input Types</CardTitle>
                <CardDescription>Various input components for data collection</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <Input placeholder="Default input" />
                <Input placeholder="Input with error" error="This field is required" />
                <Input placeholder="Input with success" success="Valid input" />
                <PasswordInput placeholder="Password" />
                <SearchInput placeholder="Search security logs..." />
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Input Sizes & Icons</CardTitle>
                <CardDescription>Different sizes and icon configurations</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <Input size="sm" placeholder="Small input" />
                <Input size="md" placeholder="Medium input" />
                <Input size="lg" placeholder="Large input" />
                <Input 
                  leftIcon={<Users className="h-4 w-4" />} 
                  placeholder="With left icon" 
                />
                <Input 
                  rightIcon={<Server className="h-4 w-4" />} 
                  placeholder="With right icon" 
                />
              </CardContent>
            </Card>
          </div>
        </section>

        {/* Cards Section */}
        <section className="mb-12">
          <Heading variant="h2" className="mb-6">
            Cards & Containers
          </Heading>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <Card variant="default">
              <CardHeader>
                <CardTitle>Default Card</CardTitle>
                <CardDescription>Standard card styling</CardDescription>
              </CardHeader>
              <CardContent>
                <Text>This is a default card with standard styling and subtle borders.</Text>
              </CardContent>
            </Card>

            <Card variant="elevated">
              <CardHeader>
                <CardTitle>Elevated Card</CardTitle>
                <CardDescription>Enhanced with shadow</CardDescription>
              </CardHeader>
              <CardContent>
                <Text>This card has enhanced shadow effects for better visual hierarchy.</Text>
              </CardContent>
            </Card>

            <Card variant="glow">
              <CardHeader>
                <CardTitle>Glow Card</CardTitle>
                <CardDescription>Subtle background glow</CardDescription>
              </CardHeader>
              <CardContent>
                <Text>Features a subtle radial gradient background for depth.</Text>
              </CardContent>
            </Card>

            <Card variant="outline" interactive>
              <CardHeader>
                <CardTitle>Interactive Card</CardTitle>
                <CardDescription>Hover and click effects</CardDescription>
              </CardHeader>
              <CardContent>
                <Text>This card responds to user interaction with hover and click effects.</Text>
              </CardContent>
            </Card>

            <Card variant="gradient" className="md:col-span-2">
              <CardHeader>
                <CardTitle>Gradient Card</CardTitle>
                <CardDescription>Navy gradient background</CardDescription>
              </CardHeader>
              <CardContent>
                <Text>Features the signature navy-blue gradient background perfect for highlights.</Text>
              </CardContent>
              <CardFooter>
                <Button variant="secondary" size="sm">
                  Learn More
                </Button>
              </CardFooter>
            </Card>
          </div>
        </section>

        {/* Typography Section */}
        <section className="mb-12">
          <Heading variant="h2" className="mb-6">
            Typography
          </Heading>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Card>
              <CardHeader>
                <CardTitle>Headings</CardTitle>
                <CardDescription>Various heading levels and weights</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <Heading variant="h1">Heading 1</Heading>
                <Heading variant="h2">Heading 2</Heading>
                <Heading variant="h3">Heading 3</Heading>
                <Heading variant="h4">Heading 4</Heading>
                <Heading variant="h5">Heading 5</Heading>
                <Heading variant="h6">Heading 6</Heading>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Text & Links</CardTitle>
                <CardDescription>Body text, captions, and link styles</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <Text variant="subtitle1">Subtitle 1 - Important information</Text>
                <Text variant="subtitle2">Subtitle 2 - Secondary information</Text>
                <Text variant="body1">Body 1 - Main content text with good readability</Text>
                <Text variant="body2">Body 2 - Smaller body text for details</Text>
                <Text variant="caption">Caption - Small descriptive text</Text>
                <Text variant="overline">OVERLINE - UPPERCASE LABEL TEXT</Text>
                <div className="space-x-4">
                  <Link href="#" variant="default">Default Link</Link>
                  <Link href="#" variant="muted">Muted Link</Link>
                  <Link href="#" variant="accent">Accent Link</Link>
                </div>
                <Code variant="inline">inline code</Code>
              </CardContent>
            </Card>
          </div>
        </section>

        {/* Badges Section */}
        <section className="mb-12">
          <Heading variant="h2" className="mb-6">
            Badges & Tags
          </Heading>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Card>
              <CardHeader>
                <CardTitle>Badge Variants</CardTitle>
                <CardDescription>Status indicators and labels</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex flex-wrap gap-2">
                  <Badge variant="default">Default</Badge>
                  <Badge variant="secondary">Secondary</Badge>
                  <Badge variant="outline">Outline</Badge>
                  <Badge variant="success">Success</Badge>
                  <Badge variant="warning">Warning</Badge>
                  <Badge variant="danger">Alert</Badge>
                  <Badge variant="muted">Muted</Badge>
                </div>
                <div className="flex flex-wrap gap-2">
                  <Badge size="sm">Small</Badge>
                  <Badge size="md">Medium</Badge>
                  <Badge size="lg">Large</Badge>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Status & Tags</CardTitle>
                <CardDescription>System status and categorical tags</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex flex-wrap gap-2">
                  <StatusBadge status="online" />
                  <StatusBadge status="offline" />
                  <StatusBadge status="busy" />
                  <StatusBadge status="away" />
                  <StatusBadge status="idle" />
                </div>
                <div className="flex flex-wrap gap-2">
                  <Tag>Security</Tag>
                  <Tag>Network</Tag>
                  <Tag>Critical</Tag>
                  <Tag dismissible onDismiss={() => {}}>Dismissible</Tag>
                </div>
              </CardContent>
            </Card>
          </div>
        </section>

        {/* Security Dashboard Preview */}
        <section className="mb-12">
          <Heading variant="h2" className="mb-6">
            Dashboard Preview
          </Heading>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <Card variant="elevated">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Activity className="h-5 w-5 text-success" />
                  System Health
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <Text variant="body2">CPU Usage</Text>
                    <Badge variant="success">45%</Badge>
                  </div>
                  <div className="flex justify-between">
                    <Text variant="body2">Memory</Text>
                    <Badge variant="warning">78%</Badge>
                  </div>
                  <div className="flex justify-between">
                    <Text variant="body2">Network</Text>
                    <Badge variant="success">Normal</Badge>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card variant="elevated">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <AlertTriangle className="h-5 w-5 text-warning" />
                  Active Alerts
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <Text variant="body2">Failed Login Attempts</Text>
                    <Badge variant="danger">12</Badge>
                  </div>
                  <div className="flex items-center justify-between">
                    <Text variant="body2">Suspicious Network Activity</Text>
                    <Badge variant="warning">3</Badge>
                  </div>
                  <div className="flex items-center justify-between">
                    <Text variant="body2">System Updates Pending</Text>
                    <Badge variant="outline">2</Badge>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card variant="elevated">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Users className="h-5 w-5 text-primary-400" />
                  Active Sessions
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  <div className="flex items-center justify-between">
                    <div>
                      <Text variant="body2">admin@company.com</Text>
                      <Text variant="caption">192.168.1.100</Text>
                    </div>
                    <StatusBadge status="online" />
                  </div>
                  <div className="flex items-center justify-between">
                    <div>
                      <Text variant="body2">security@company.com</Text>
                      <Text variant="caption">10.0.0.50</Text>
                    </div>
                    <StatusBadge status="away" />
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="border-t border-neutral-700 bg-surface/30 backdrop-blur">
        <div className="container mx-auto px-6 py-8">
          <div className="text-center">
            <Text variant="caption">
              Security Dashboard - Built with Next.js, TypeScript, and Tailwind CSS
            </Text>
          </div>
        </div>
      </footer>
    </div>
  )
}