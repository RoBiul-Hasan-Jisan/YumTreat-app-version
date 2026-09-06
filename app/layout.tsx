import type { Metadata } from "next";
import { Space_Grotesk, IBM_Plex_Sans } from "next/font/google";
import "./globals.css";
import Header from "@/components/Header";
import Footer from "@/components/Footer";

const display = Space_Grotesk({
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-display",
  display: "swap",
});

const body = IBM_Plex_Sans({
  subsets: ["latin"],
  weight: ["400", "500", "600"],
  variable: "--font-body",
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL("https://pleronlabs.com"),
  title: {
    default: "Pleron Labs — Turning Complex Ideas Into Exceptional Software",
    template: "%s — Pleron Labs",
  },
  description:
    "Pleron Labs builds web, mobile, and AI-powered software — custom or ready-made — for businesses across every sector. AI/ML systems, enterprise ERP, and high-scale web platforms, engineered to ISO 9001, ISO 27001, and GDPR standards, delivered to clients across the Middle East, Europe, and North America.",
  openGraph: {
    title: "Pleron Labs — Turning Complex Ideas Into Exceptional Software",
    description:
      "Web, mobile, and AI-powered software for businesses across every sector — built by senior engineers to international standards.",
    url: "https://pleronlabs.com",
    siteName: "Pleron Labs",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Pleron Labs — Turning Complex Ideas Into Exceptional Software",
    description:
      "Web, mobile, and AI-powered software for businesses across every sector — built by senior engineers to international standards.",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${display.variable} ${body.variable}`}>
      <body className="font-body bg-ink-900 text-ink-100 antialiased">
        <Header />
        <main>{children}</main>
        <Footer />
      </body>
    </html>
  );
}
