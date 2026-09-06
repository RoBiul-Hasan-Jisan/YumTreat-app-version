import type { Metadata } from "next";
import { Section, SectionHead } from "@/components/Section";

export const metadata: Metadata = { title: "Terms of Service" };

export default function TermsPage() {
  return (
    <Section className="pb-24 pt-16 md:pt-20">
      <SectionHead title="Terms of Service" />
      <div className="mt-8 max-w-2xl space-y-5 text-[15px] leading-relaxed text-ink-300">
        <p>
          These terms govern use of the Pleron Labs website and engagement with our services. By
          contacting us or entering into a services agreement, you agree to the scope, payment, and
          intellectual property terms set out in that agreement.
        </p>
        <p>
          Project-specific terms, including ownership of delivered code and confidentiality obligations,
          are defined in each client's signed statement of work rather than on this page. Contact us for
          a copy of our standard agreement.
        </p>
      </div>
    </Section>
  );
}
