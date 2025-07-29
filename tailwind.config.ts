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
        // Greys and background
        background: {
          DEFAULT: '#0B0C10', // near black
          light: '#1C1F26',
          deep: '#050507'
        },
        surface: {
          DEFAULT: '#1A1D24', // for panels/cards
          subtle: '#23272E',
        },
        neutral: {
          100: '#E5E7EB',
          200: '#D1D5DB',
          300: '#9CA3AF',
          400: '#6B7280',
          500: '#4B5563',
          600: '#374151',
          700: '#1F2937',
          800: '#111827',
          900: '#0B0C10',
        },

        // Primary blue gradient tones
        primary: {
          100: '#C7D7FF',
          200: '#A6BDFD',
          300: '#7F9FFB',
          400: '#587FF8',
          500: '#325FF6', // main blue for links/buttons
          600: '#1E3A8A', // deep navy
          700: '#162A63',
          800: '#101A47',
          900: '#0A102F',
        },

        // Highlight blue (used sparingly)
        highlight: {
          DEFAULT: '#6EC1E4', // calm, friendly cyan-blue
          soft: '#A1D7F1',
        },

        // Alerts and status
        danger: '#DC2626',
        success: '#10B981',
        warning: '#F59E0B',

        // Accent gradients
        gradientStart: '#101A47',
        gradientMid: '#1E3A8A',
        gradientEnd: '#325FF6',
      },

      backgroundImage: {
        'navy-gradient': 'linear-gradient(to bottom right, #101A47, #1E3A8A, #325FF6)',
        'surface-glow': 'radial-gradient(circle at 30% 30%, rgba(50,95,246,0.05), transparent 80%)',
      },

      boxShadow: {
        focus: '0 0 0 2px rgba(50, 95, 246, 0.5)', // subtle focus ring
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