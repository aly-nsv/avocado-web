'use client'

import * as React from 'react'
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from '@/lib/utils'

const headingVariants = cva(
  'font-semibold tracking-tight text-neutral-100',
  {
    variants: {
      variant: {
        h1: 'text-4xl lg:text-5xl',
        h2: 'text-3xl lg:text-4xl',
        h3: 'text-2xl lg:text-3xl',
        h4: 'text-xl lg:text-2xl',
        h5: 'text-lg lg:text-xl',
        h6: 'text-base lg:text-lg',
      },
      weight: {
        light: 'font-light',
        normal: 'font-normal',
        medium: 'font-medium',
        semibold: 'font-semibold',
        bold: 'font-bold',
      },
    },
    defaultVariants: {
      variant: 'h1',
      weight: 'semibold',
    },
  }
)

export interface HeadingProps
  extends React.HTMLAttributes<HTMLHeadingElement>,
    VariantProps<typeof headingVariants> {
  as?: 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6'
}

const Heading = React.forwardRef<HTMLHeadingElement, HeadingProps>(
  ({ className, variant, weight, as, ...props }, ref) => {
    const Comp = as || variant || 'h1'
    return (
      <Comp
        ref={ref}
        className={cn(headingVariants({ variant, weight, className }))}
        {...props}
      />
    )
  }
)
Heading.displayName = 'Heading'

const textVariants = cva(
  'text-neutral-200',
  {
    variants: {
      variant: {
        body1: 'text-base leading-7',
        body2: 'text-sm leading-6',
        caption: 'text-xs leading-5 text-neutral-400',
        overline: 'text-xs uppercase tracking-wider font-medium text-neutral-300',
        subtitle1: 'text-lg leading-7 font-medium',
        subtitle2: 'text-base leading-6 font-medium',
      },
      weight: {
        light: 'font-light',
        normal: 'font-normal',
        medium: 'font-medium',
        semibold: 'font-semibold',
        bold: 'font-bold',
      },
    },
    defaultVariants: {
      variant: 'body1',
      weight: 'normal',
    },
  }
)

export interface TextProps
  extends React.HTMLAttributes<HTMLElement>,
    VariantProps<typeof textVariants> {
  as?: 'p' | 'span' | 'div' | 'label'
}

const Text = React.forwardRef<any, TextProps>(
  ({ className, variant, weight, as = 'p', ...props }, ref) => {
    const Comp = as
    return (
      <Comp
        ref={ref}
        className={cn(textVariants({ variant, weight, className }))}
        {...props}
      />
    )
  }
)
Text.displayName = 'Text'

const linkVariants = cva(
  'transition-colors underline-offset-4 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary-400/50 focus-visible:ring-offset-2 rounded-sm',
  {
    variants: {
      variant: {
        default: 'text-primary-300 hover:text-primary-200',
        muted: 'text-neutral-400 hover:text-neutral-300',
        accent: 'text-highlight hover:text-highlight-soft',
      },
    },
    defaultVariants: {
      variant: 'default',
    },
  }
)

export interface LinkProps
  extends React.AnchorHTMLAttributes<HTMLAnchorElement>,
    VariantProps<typeof linkVariants> {}

const Link = React.forwardRef<HTMLAnchorElement, LinkProps>(
  ({ className, variant, ...props }, ref) => {
    return (
      <a
        ref={ref}
        className={cn(linkVariants({ variant, className }))}
        {...props}
      />
    )
  }
)
Link.displayName = 'Link'

const codeVariants = cva(
  'font-mono rounded px-[0.3rem] py-[0.2rem] text-sm',
  {
    variants: {
      variant: {
        inline: 'bg-surface text-neutral-200',
        block: 'bg-background border border-neutral-700 p-4 overflow-x-auto',
      },
    },
    defaultVariants: {
      variant: 'inline',
    },
  }
)

export interface CodeProps
  extends React.HTMLAttributes<HTMLElement>,
    VariantProps<typeof codeVariants> {}

const Code = React.forwardRef<HTMLElement, CodeProps>(
  ({ className, variant, ...props }, ref) => {
    return (
      <code
        ref={ref}
        className={cn(codeVariants({ variant, className }))}
        {...props}
      />
    )
  }
)
Code.displayName = 'Code'

export { 
  Heading, 
  Text, 
  Link, 
  Code, 
  headingVariants, 
  textVariants, 
  linkVariants, 
  codeVariants 
}