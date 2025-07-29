import { ReactNode } from 'react'

export type Size = 'xs' | 'sm' | 'md' | 'lg' | 'xl'
export type Variant = 'primary' | 'secondary' | 'outline' | 'ghost' | 'link' | 'danger' | 'success'
export type State = 'default' | 'hover' | 'active' | 'disabled' | 'loading'

export interface BaseComponentProps {
  className?: string
  children?: ReactNode
  size?: Size
  variant?: Variant
  disabled?: boolean
}

export interface IconProps {
  size?: number
  className?: string
}