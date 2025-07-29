# Claude Code Instructions

This document contains specific instructions for Claude Code when working on this security dashboard project.

## 🔧 **Build & Type Checking Requirements**

### **CRITICAL: Always Verify Build Success**
After **every code change**, you MUST run the following commands to ensure the project remains functional:

```bash
npm run type-check
npm run build
```

**Never consider a task complete until both commands pass without errors.**

### **TypeScript Error Handling**
- **Zero tolerance for TypeScript errors** - all `ts(xxxx)` errors must be resolved
- Always run `npm run type-check` before and after making changes
- If you encounter TypeScript errors, fix them immediately rather than leaving them for later
- Use proper TypeScript interfaces and types from `@/types/component.ts`

## 🏗️ **Project Architecture**

### **Component Development**
- All UI components are located in `src/components/ui/`
- Each component should export its main component and any variants
- Use the established patterns from existing components (Button, Input, Card, etc.)
- Follow the `cva` (class-variance-authority) pattern for styling variants
- Always include proper TypeScript interfaces extending base component props

### **Styling Guidelines**
- Use the custom Tailwind theme defined in `tailwind.config.ts`
- Stick to the dark-first design system with navy-blue gradients
- Color palette: `background`, `surface`, `primary`, `neutral`, `highlight`
- Never use arbitrary values - use theme tokens only

### **File Organization**
```
src/
├── app/                 # Next.js app router pages
├── components/ui/       # Reusable UI components
├── lib/                 # Utility functions
└── types/              # TypeScript type definitions
```

## 🧪 **Testing & Quality Assurance**

### **Required Commands After Changes**
1. `npm run type-check` - Verify TypeScript compilation
2. `npm run build` - Ensure production build succeeds  
3. `npm run lint` - Check for linting issues (if available)

### **Development Workflow**
1. Make code changes
2. Run type checking immediately
3. Fix any TypeScript errors
4. Test build compilation
5. Only then consider the task complete

## 🔮 **Future Architecture Considerations**

### **WebSocket & Real-time Data**
- The component architecture is designed to easily accept streaming data
- When implementing WebSocket connections, use React context for state management
- Components should accept data props rather than fetching data directly
- Plan for real-time updates in dashboard cards and status indicators

### **Performance Optimization**
- Components are built with performance in mind using proper React patterns
- Use React.memo for components that receive frequent updates
- Implement proper loading states for async operations

## 🚨 **Security Considerations**

### **Defensive Security Focus**
- This is a **security dashboard** - never introduce vulnerabilities
- All form inputs should be properly validated
- Never log or expose sensitive information
- Follow security best practices for authentication and data handling

### **Code Review Checklist**
- [ ] No TypeScript errors
- [ ] Build succeeds without warnings
- [ ] No console.log statements with sensitive data
- [ ] Proper error boundaries implemented
- [ ] Input validation in place

## 📝 **Component Standards**

### **Required Component Structure**
```typescript
'use client' // If using hooks or client-side features

import * as React from 'react'
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from '@/lib/utils'

const componentVariants = cva(/* base styles */, {
  variants: {
    variant: { /* variants */ },
    size: { /* sizes */ },
  },
  defaultVariants: { /* defaults */ },
})

export interface ComponentProps extends React.HTMLAttributes<HTMLElement>, VariantProps<typeof componentVariants> {
  // Additional props
}

const Component = React.forwardRef<HTMLElement, ComponentProps>(({ className, variant, size, ...props }, ref) => {
  return (
    <element
      ref={ref}
      className={cn(componentVariants({ variant, size, className }))}
      {...props}
    />
  )
})

Component.displayName = 'Component'

export { Component, componentVariants }
```

## 🛠️ **Debugging Guidelines**

### **Common Issues & Solutions**
- **Build fails**: Check for TypeScript errors first
- **Styling issues**: Verify Tailwind classes exist in config
- **Import errors**: Check file paths and exports
- **Runtime errors**: Check browser console and fix immediately

### **Available Scripts**
- `npm run dev` - Start development server
- `npm run build` - Production build
- `npm run start` - Start production server
- `npm run type-check` - TypeScript compilation check
- `npm run lint` - ESLint checking

## 🎯 **Success Criteria**

A task is only complete when:
- [ ] All TypeScript errors are resolved
- [ ] `npm run type-check` passes
- [ ] `npm run build` succeeds
- [ ] Code follows established patterns
- [ ] Components are properly exported
- [ ] No runtime errors in browser console

**Remember: The build must always work. Never leave the project in a broken state.**