import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // New refined color palette
        background: {
          DEFAULT: '#171E25', // Deep navy background
          light: '#2B3744',   // Charcoal slate
          deep: '#171E25',    // Same as default for consistency
        },
        surface: {
          DEFAULT: '#2B3744', // Charcoal slate for panels/cards
          subtle: '#354A5A',  // Muted steel blue
        },
        neutral: {
          100: '#B2CBE0',     // Pale blue highlight
          200: '#9BB4CC',     // Light steel blue  
          300: '#6C909C',     // Dusty teal-gray
          400: '#58738C',     // Desaturated blue-gray
          500: '#4D5661',     // Medium slate gray
          600: '#354A5A',     // Muted steel blue
          700: '#2B3744',     // Charcoal slate
          800: '#171E25',     // Deep navy
          900: '#171E25',     // Deep navy
        },

        // Primary color system using the refined palette
        primary: {
          100: '#B2CBE0',     // Pale blue highlight
          200: '#9BB4CC',     // Light steel blue
          300: '#6C909C',     // Dusty teal-gray
          400: '#58738C',     // Desaturated blue-gray
          500: '#4D5661',     // Medium slate gray - main color
          600: '#354A5A',     // Muted steel blue
          700: '#2B3744',     // Charcoal slate
          800: '#171E25',     // Deep navy
          900: '#171E25',     // Deep navy
        },

        // Bright accent colors
        accent: {
          DEFAULT: '#0F9960', // Bright teal/green accent
          success: '#0F9960', // Same as accent
          danger: '#A04E54',  // Muted crimson accent
        },

        // Status colors using the new palette
        success: '#0F9960',   // Bright teal/green
        danger: '#A04E54',    // Muted crimson
        warning: '#58738C',   // Using desaturated blue-gray for warnings

        // Highlight color
        highlight: {
          DEFAULT: '#9BB4CC', // Light steel blue
          soft: '#B2CBE0',    // Pale blue highlight
        },

        // Gradient colors using new palette
        gradientStart: '#171E25',  // Deep navy
        gradientMid: '#2B3744',    // Charcoal slate
        gradientEnd: '#354A5A',    // Muted steel blue
      },

      backgroundImage: {
        'navy-gradient': 'linear-gradient(to bottom right, #171E25, #2B3744, #354A5A)',
        'surface-glow': 'radial-gradient(circle at 30% 30%, rgba(77,86,97,0.1), transparent 80%)',
      },

      boxShadow: {
        focus: '0 0 0 2px rgba(77, 86, 97, 0.5)', // subtle focus ring using medium slate gray
        elevated: '0 4px 20px rgba(0,0,0,0.6)',
      },

      borderRadius: {
        xl: '1rem',
        '2xl': '1.25rem',
      },

      fontFamily: {
        sans: ['Inter', 'ui-sans-serif', 'system-ui'],
        mono: ['Fira Code', 'ui-monospace', 'SFMono-Regular'],
      }
    },
  },
  plugins: [],
}
export default config