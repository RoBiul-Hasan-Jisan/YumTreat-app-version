import Link from "next/link";
import { Section } from "@/components/Section";

export default function NotFound() {
  return (
    <Section className="py-32 text-center">
      <p className="text-[13px] text-brass">404</p>
      <h1 className="mt-3 font-display text-[32px] font-medium text-ink-50">Page not found</h1>
      <p className="mt-3 text-[15px] text-ink-300">The page you're looking for doesn't exist or has moved.</p>
      <Link
        href="/"
        className="mt-7 inline-block rounded-sm border border-ink-600 px-6 py-3 text-[14px] text-ink-100 hover:border-brass/60"
      >
        Back to home
      </Link>
    </Section>
  );
}
