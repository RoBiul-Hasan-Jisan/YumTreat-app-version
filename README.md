# Pleron Labs — Marketing Website

A Next.js 14 (App Router + TypeScript + Tailwind CSS) corporate/agency site built from the
"Pleron Labs" brief: software & AI development positioning, dark premium design system, and the
full page/section structure requested (Home, Services, Projects, Industries, Company, Blog,
Careers, Contact).

## Getting started

Requires Node.js 18.18+ (Node 20 LTS recommended).

```bash
npm install
npm run dev
```

Visit http://localhost:3000.

To build for production:

```bash
npm run build
npm run start
```

> **Note on fonts:** the site loads Space Grotesk and IBM Plex Sans via `next/font/google` in
> `app/layout.tsx`. This requires network access to `fonts.googleapis.com` at build time (normal
> on any standard dev machine or CI/host). If you're building in a fully offline/sandboxed
> environment, swap the font imports in `app/layout.tsx` for a local/self-hosted font or a system
> font stack.

## Project structure

```
app/
  layout.tsx            Root layout, fonts, metadata (OG/Twitter), Header/Footer
  page.tsx               Homepage — all sections from the brief
  services/page.tsx      All 8 services, detailed
  projects/page.tsx      Project grid
  projects/[slug]/       Individual case study pages
  industries/page.tsx    9 industry tiles
  company/page.tsx       About / positioning / compliance
  blog/page.tsx          Blog index
  blog/[slug]/           Individual posts
  careers/page.tsx       Open roles
  contact/page.tsx       Contact form + channels
  terms/, privacy/       Legal pages
components/
  Header.tsx, Footer.tsx
  HeroCarousel.tsx        Rotating project-screen carousel (client component)
  RotatingWord.tsx        Animated gradient headline word rotation
  ProjectMockup.tsx        Abstract SVG "screenshot" mockups (swap for real screenshots)
  StatsRow.tsx, ServicesGrid.tsx, FeaturedProjects.tsx, IndustriesGrid.tsx,
  ZeroRiskTrial.tsx, EngagementModels.tsx, ContactForm.tsx, Section.tsx
lib/
  data.ts     Services / projects / industries content
  blog.ts     Blog post content
```

## Content to swap before launch

- **Company name & copy:** search for "Pleron Labs" across `app/` and `components/` and replace
  with your actual brand name; update the tagline/copy in `app/page.tsx` and `app/layout.tsx`
  metadata.
- **Real project screenshots:** `components/ProjectMockup.tsx` renders abstract SVG mockups
  standing in for real product screenshots. Replace with actual images (e.g. `hero/one.webp` →
  `five.webp` in `/public`) and swap `HeroCarousel.tsx` / `FeaturedProjects.tsx` to use
  `next/image` instead.
- **Contact form:** `components/ContactForm.tsx` currently just shows a success state on submit.
  Wire it to your email/CRM endpoint (e.g. a Next.js Route Handler, Resend, or a form service).
- **OG image:** add a real `public/og-image.png` (1200×630) and reference it in the `openGraph`/
  `twitter` metadata blocks in `app/layout.tsx`.
- **Location, email, socials:** update in `components/Footer.tsx` and `app/contact/page.tsx`.

## Design system

- Background: near-black graphite (`#0C0E11`), card surfaces (`#16181C`), hairline borders
  instead of drop shadows.
- Accent: brass/gold (`#C9A15A`) with a muted cool-blue secondary (`#6B87FF`), used sparingly.
- Type: Space Grotesk (display/headings) + IBM Plex Sans (body) — see `tailwind.config.ts`.
- All tokens live in `tailwind.config.ts` under `theme.extend`.
