# Security Dashboard

A modern, dark-first security operations dashboard built with Next.js, TypeScript, and Tailwind CSS. Features a comprehensive component library designed for real-time monitoring and security data visualization.

## 🚀 **Quick Start**

### **Prerequisites**
- **Node.js 18+** and **npm** or **yarn**
- **Git** for version control

### **Installation**

1. **Clone and setup**:
   ```bash
   git clone <repository-url>
   cd avocado
   npm install
   ```

2. **Start development server**:
   ```bash
   npm run dev
   ```

3. **Open in browser**:
   ```
   http://localhost:3000
   ```

### **Available Scripts**

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server with hot reload |
| `npm run build` | Create production build |
| `npm run start` | Start production server |
| `npm run type-check` | Run TypeScript type checking |
| `npm run lint` | Run ESLint code analysis |

## 🎨 **Design System**

### **Color Palette**
Our dark-first theme uses a carefully crafted navy-blue gradient system:

- **Background**: `#0B0C10` (near black) to `#1C1F26` (dark gray)
- **Surface**: `#1A1D24` (panels) to `#23272E` (subtle variants)
- **Primary**: Navy blues from `#325FF6` to `#0A102F`
- **Highlight**: Soft cyan `#6EC1E4` for accents
- **Status**: Success `#10B981`, Warning `#F59E0B`, Danger `#DC2626`

### **Typography**
- **Primary**: Inter font family for UI text
- **Monospace**: Fira Code for code blocks and technical content

## 🧩 **Component Library**

### **Core Components**

#### **Buttons**
```tsx
import { Button } from '@/components/ui'

// Variants: primary, secondary, outline, ghost, link, danger, success
<Button variant="primary" size="md">Primary Button</Button>
<Button variant="outline" size="lg" leftIcon={<Icon />}>With Icon</Button>
<Button loading>Loading State</Button>
```

#### **Form Inputs**
```tsx
import { Input, PasswordInput, SearchInput } from '@/components/ui'

<Input placeholder="Standard input" />
<Input error="Error message" />
<PasswordInput placeholder="Password" />
<SearchInput placeholder="Search..." />
```

#### **Cards & Layout**
```tsx
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui'

<Card variant="elevated">
  <CardHeader>
    <CardTitle>Card Title</CardTitle>
  </CardHeader>
  <CardContent>Card content here</CardContent>
</Card>
```

#### **Typography**
```tsx
import { Heading, Text, Link } from '@/components/ui'

<Heading variant="h2">Section Title</Heading>
<Text variant="body1">Body text content</Text>
<Link href="#" variant="accent">Styled Link</Link>
```

#### **Status & Labels**
```tsx
import { Badge, StatusBadge, Tag } from '@/components/ui'

<Badge variant="success">Success</Badge>
<StatusBadge status="online">System Online</StatusBadge>
<Tag dismissible onDismiss={() => {}}>Dismissible Tag</Tag>
```

### **Component Features**
- **Multiple sizes**: xs, sm, md, lg, xl for most components
- **Variant support**: Primary/secondary states with consistent styling
- **TypeScript**: Full type safety with proper interfaces
- **Accessibility**: ARIA labels, keyboard navigation, focus management
- **Responsive**: Mobile-first design with breakpoint support

## 🔧 **Development**

### **Project Structure**
```
src/
├── app/                    # Next.js app router
│   ├── globals.css        # Global styles
│   ├── layout.tsx         # Root layout
│   └── page.tsx           # Demo page
├── components/ui/         # Component library
│   ├── Button.tsx         # Button variants
│   ├── Input.tsx          # Form inputs
│   ├── Card.tsx           # Card system
│   ├── Typography.tsx     # Text components
│   ├── Badge.tsx          # Labels & status
│   └── index.ts           # Exports
├── lib/
│   └── utils.ts           # Utilities (cn helper)
└── types/
    └── component.ts       # TypeScript interfaces
```

### **Adding New Components**

1. **Create component file** in `src/components/ui/`
2. **Follow the established pattern**:
   ```tsx
   'use client'
   
   import * as React from 'react'
   import { cva, type VariantProps } from 'class-variance-authority'
   import { cn } from '@/lib/utils'
   
   const componentVariants = cva(/* styles */)
   
   export interface ComponentProps extends React.HTMLAttributes<HTMLElement>, VariantProps<typeof componentVariants> {}
   
   const Component = React.forwardRef<HTMLElement, ComponentProps>(...)
   
   export { Component }
   ```
3. **Add to exports** in `src/components/ui/index.ts`
4. **Test thoroughly** with TypeScript and build checks

### **Styling Guidelines**

- **Use theme tokens**: Reference colors from `tailwind.config.ts`
- **Follow dark-first**: Default to dark backgrounds and light text
- **Consistent spacing**: Use Tailwind's spacing scale (4, 6, 8, 12, etc.)
- **Navy gradients**: Use sparingly for emphasis and call-to-action elements

## 🛠️ **Troubleshooting**

### **Common Issues**

#### **Build Failures**
```bash
# Check TypeScript errors
npm run type-check

# Check for syntax issues
npm run lint

# Clear Next.js cache
rm -rf .next
npm run build
```

#### **Styling Issues**
- Verify Tailwind classes exist in `tailwind.config.ts`
- Check for typos in custom color names
- Ensure proper `cn()` usage for conditional classes

#### **Import Errors**
- Verify file paths and extensions
- Check component exports in `index.ts`
- Ensure TypeScript paths are configured correctly

#### **Development Server Issues**
```bash
# Kill existing processes
lsof -ti:3000 | xargs kill -9

# Clear npm cache
npm cache clean --force

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### **Debug Mode**
Enable detailed error messages:
```bash
# Development with debug info
DEBUG=* npm run dev

# TypeScript with verbose output
npx tsc --noEmit --pretty
```

## 🔮 **Future Development**

### **Planned Features**
- **WebSocket integration** for real-time data streams
- **Advanced data visualization** (charts, graphs, metrics)
- **Authentication system** with role-based access
- **Dashboard customization** with drag-and-drop widgets
- **API integration layer** for security monitoring tools
- **Mobile-responsive** dashboard layouts

### **Architecture Considerations**
- Components are designed for **streaming data** integration
- **Performance optimized** for frequent updates
- **Modular design** allows easy feature additions
- **Security-first** approach with input validation

## 📚 **Resources**

### **Documentation**
- [Next.js Documentation](https://nextjs.org/docs)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Lucide Icons](https://lucide.dev/)

### **Component Libraries Reference**
- [Radix UI](https://www.radix-ui.com/) - Unstyled component primitives
- [Class Variance Authority](https://cva.style/docs) - Type-safe variant systems
- [Tailwind Merge](https://github.com/dcastil/tailwind-merge) - Conflicting class resolution

## 🤝 **Contributing**

### **Development Workflow**
1. Create feature branch from `main`
2. Make changes following component patterns
3. Run type checking: `npm run type-check`
4. Test build: `npm run build`
5. Submit pull request with clear description

### **Code Standards**
- **TypeScript strict mode** - zero tolerance for type errors
- **Component consistency** - follow established patterns
- **Accessibility first** - proper ARIA labels and keyboard navigation
- **Security conscious** - validate inputs, avoid XSS vulnerabilities

## 📄 **License**

This project is private and proprietary. All rights reserved.

---

**Need help?** Check the `CHANGELOG.md` for recent updates or review `CLAUDE.md` for development guidelines.