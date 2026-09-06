import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        ink: {
          DEFAULT: "#0C0E11",
          50: "#F5F5F6",
          100: "#E7E8EA",
          200: "#B9BCC2",
          300: "#8A8F98",
          400: "#5C616B",
          500: "#3A3E45",
          600: "#262930",
          700: "#1B1D22",
          800: "#16181C",
          900: "#0C0E11",
        },
        brass: {
          DEFAULT: "#C9A15A",
          light: "#E4C688",
          dark: "#9C7A3E",
        },
        slate: {
          accent: "#6B87FF",
        },
      },
      fontFamily: {
        display: ["var(--font-display)", "sans-serif"],
        body: ["var(--font-body)", "sans-serif"],
      },
      maxWidth: {
        content: "1240px",
      },
      borderRadius: {
        sm: "4px",
        DEFAULT: "8px",
        lg: "12px",
      },
      backgroundImage: {
        "grain": "radial-gradient(circle at 1px 1px, rgba(255,255,255,0.035) 1px, transparent 0)",
      },
    },
  },
  plugins: [],
};
export default config;
