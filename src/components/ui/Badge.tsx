'use client'

import * as React from 'react'
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from '@/lib/utils'
import { X } from 'lucide-react'

const badgeVariants = cva(
  'inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-primary-400/50 focus:ring-offset-2',
  {
    variants: {
      variant: {
        default: 'border-transparent bg-primary-500 text-neutral-100 hover:bg-primary-400',
        secondary: 'border-transparent bg-surface text-neutral-200 hover:bg-surface-subtle',
        outline: 'border-primary-400 text-primary-300 hover:bg-primary-400/10',
        success: 'border-transparent bg-success text-white',
        warning: 'border-transparent bg-warning text-white',
        danger: 'border-transparent bg-danger text-white',
        muted: 'border-transparent bg-neutral-700 text-neutral-300',
      },
      size: {
        sm: 'px-2 py-0.5 text-xs',
        md: 'px-2.5 py-0.5 text-xs',
        lg: 'px-3 py-1 text-sm',
      },
    },
    defaultVariants: {
      variant: 'default',
      size: 'md',
    },
  }
)

export interface BadgeProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof badgeVariants> {
  dismissible?: boolean
  onDismiss?: () => void
}

const Badge = React.forwardRef<HTMLDivElement, BadgeProps>(
  ({ className, variant, size, dismissible, onDismiss, children, ...props }, ref) => {
    return (
      <div
        ref={ref}
        className={cn(badgeVariants({ variant, size }), className)}
        {...props}
      >
        {children}
        {dismissible && onDismiss && (
          <button
            onClick={onDismiss}
            className="ml-1 hover:bg-black/20 rounded-full p-0.5 transition-colors"
            type="button"
          >
            <X className="h-3 w-3" />
          </button>
        )}
      </div>
    )
  }
)
Badge.displayName = 'Badge'

const StatusBadge = React.forwardRef<
  HTMLDivElement,
  Omit<BadgeProps, 'variant'> & {
    status: 'online' | 'offline' | 'busy' | 'away' | 'idle'
  }
>(({ status, className, children, ...props }, ref) => {
  const statusVariants = {
    online: 'success',
    offline: 'muted',
    busy: 'danger',
    away: 'warning',
    idle: 'secondary',
  } as const

  const statusIcons = {
    online: '●',
    offline: '●',
    busy: '●',
    away: '●',
    idle: '●',
  }

  return (
    <Badge
      ref={ref}
      variant={statusVariants[status]}
      className={cn('gap-1', className)}
      {...props}
    >
      <span className="text-xs">{statusIcons[status]}</span>
      {children || status}
    </Badge>
  )
})
StatusBadge.displayName = 'StatusBadge'

const Tag = React.forwardRef<
  HTMLDivElement,
  BadgeProps & {
    color?: string
  }
>(({ color, className, variant = 'outline', ...props }, ref) => {
  const style = color ? { borderColor: color, color } : undefined
  
  return (
    <Badge
      ref={ref}
      variant={variant}
      className={cn('rounded-md', className)}
      style={style}
      {...props}
    />
  )
})
Tag.displayName = 'Tag'

export { Badge, StatusBadge, Tag, badgeVariants }