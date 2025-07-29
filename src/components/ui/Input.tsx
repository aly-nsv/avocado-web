'use client'

import * as React from 'react'
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from '@/lib/utils'
import { Eye, EyeOff, Search, AlertCircle } from 'lucide-react'

const inputVariants = cva(
  'flex w-full rounded-xl border bg-surface px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-neutral-500 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary-400/50 focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 transition-all',
  {
    variants: {
      variant: {
        default: 'border-neutral-600 text-neutral-100 focus-visible:border-primary-400',
        error: 'border-danger text-neutral-100 focus-visible:border-danger',
        success: 'border-success text-neutral-100 focus-visible:border-success',
      },
      size: {
        sm: 'h-9 px-3 text-sm',
        md: 'h-11 px-4 text-base',
        lg: 'h-12 px-4 text-lg',
      },
    },
    defaultVariants: {
      variant: 'default',
      size: 'md',
    },
  }
)

export interface InputProps
  extends Omit<React.InputHTMLAttributes<HTMLInputElement>, 'size'>,
    VariantProps<typeof inputVariants> {
  leftIcon?: React.ReactNode
  rightIcon?: React.ReactNode
  error?: string
  success?: string
}

const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, variant, size, type, leftIcon, rightIcon, error, success, ...props }, ref) => {
    const inputVariant = error ? 'error' : success ? 'success' : variant

    return (
      <div className="relative w-full">
        {leftIcon && (
          <div className="absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400">
            {leftIcon}
          </div>
        )}
        <input
          type={type}
          className={cn(
            inputVariants({ variant: inputVariant, size, className }),
            leftIcon && 'pl-10',
            rightIcon && 'pr-10'
          )}
          ref={ref}
          {...props}
        />
        {rightIcon && (
          <div className="absolute right-3 top-1/2 transform -translate-y-1/2 text-neutral-400">
            {rightIcon}
          </div>
        )}
        {error && (
          <div className="flex items-center mt-1 text-danger text-xs">
            <AlertCircle className="w-3 h-3 mr-1" />
            {error}
          </div>
        )}
        {success && (
          <div className="flex items-center mt-1 text-success text-xs">
            <AlertCircle className="w-3 h-3 mr-1" />
            {success}
          </div>
        )}
      </div>
    )
  }
)
Input.displayName = 'Input'

const PasswordInput = React.forwardRef<HTMLInputElement, Omit<InputProps, 'type' | 'rightIcon'>>(
  (props, ref) => {
    const [showPassword, setShowPassword] = React.useState(false)

    return (
      <Input
        {...props}
        ref={ref}
        type={showPassword ? 'text' : 'password'}
        rightIcon={
          <button
            type="button"
            onClick={() => setShowPassword(!showPassword)}
            className="text-neutral-400 hover:text-neutral-200 transition-colors"
          >
            {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
          </button>
        }
      />
    )
  }
)
PasswordInput.displayName = 'PasswordInput'

const SearchInput = React.forwardRef<HTMLInputElement, Omit<InputProps, 'leftIcon'>>(
  (props, ref) => {
    return (
      <Input
        {...props}
        ref={ref}
        leftIcon={<Search className="w-4 h-4" />}
        placeholder="Search..."
      />
    )
  }
)
SearchInput.displayName = 'SearchInput'

export { Input, PasswordInput, SearchInput, inputVariants }