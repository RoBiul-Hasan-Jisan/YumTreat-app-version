import type { Metadata } from "next";
import { Section, SectionHead } from "@/components/Section";

export const metadata: Metadata = { title: "Privacy Policy" };

export default function PrivacyPage() {
  return (
    <Section className="pb-24 pt-16 md:pt-20">
      <SectionHead title="Privacy Policy" />
      <div className="mt-8 max-w-2xl space-y-5 text-[15px] leading-relaxed text-ink-300">
        <p>
          Pleron Labs collects only the information needed to respond to inquiries and deliver client
          projects — primarily contact details submitted through this site and project-related data
          shared under a signed agreement.
        </p>
        <p>
          We do not sell personal data to third parties. Data handling for client projects follows
          GDPR-aligned practices, including defined retention periods and a deletion path on request.
          Contact hello@pleronlabs.com for any data request.
        </p>
      </div>
    </Section>
  );
}
