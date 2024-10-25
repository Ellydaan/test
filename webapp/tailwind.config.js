/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'sulu': {
          '50': '#f6fee7',
          '100': '#ebfbcc',
          '200': '#d6f79f',
          '300': '#c0f175',
          '400': '#9de338',
          '500': '#7ec919',
          '600': '#61a010',
          '700': '#4a7a11',
          '800': '#3d6113',
          '900': '#345215',
          '950': '#192d06',
        }
      }
    },
  },
  plugins: [],
}