import type { Metadata } from "next";
import Link from "next/link";
import { Section, SectionHead } from "@/components/Section";

export const metadata: Metadata = {
  title: "Company",
  description: "Pleron Labs is a senior software engineering team based in Chattogram, Bangladesh, delivering to international standards.",
};

const values = [
  {
    title: "Senior by default",
    body: "Every engineer assigned to a project has shipped production software before joining Pleron Labs. There is no junior bench to staff a project from.",
  },
  {
    title: "Architecture first",
    body: "We scope the system before we scope the sprint. Decisions that are expensive to reverse get made deliberately, not by accident.",
  },
  {
    title: "One point of accountability",
    body: "A single technical lead owns delivery on every engagement, so nothing falls into the gap between departments.",
  },
  {
    title: "Standards, not slogans",
    body: "ISO 9001:2015, ISO 27001:2022, and GDPR alignment aren't marketing badges — they're the process every project runs on.",
  },
];

export default function CompanyPage() {
  return (
    <>
      <Section className="pb-16 pt-16 md:pt-20">
        <div className="grid grid-cols-1 gap-10 lg:grid-cols-[0.8fr_1fr]">
          <SectionHead title="Company" />
          <div className="space-y-5 text-[15.5px] leading-relaxed text-ink-300">
            <p>
              We founded Pleron Labs on a simple observation: too many software projects fail not
              because of technical limitations, but because of fragmented execution, poor
              communication, and design treated as an afterthought.
            </p>
            <p>
              We're based in Chattogram, Bangladesh, and work daily across the Middle East, Europe, and
              North America. That geography is part of the value, not something we work around — it
              lets us deliver senior-level engineering at a cost structure that a European or North
              American studio can't match, without lowering the bar on process or quality.
            </p>
            <p>
              Every engagement — an 8-hour trial or a year-long build — runs on the same discipline:
              architecture decided early, one accountable technical lead, and a compliance process built
              to ISO and GDPR standards from day one.
            </p>
          </div>
        </div>
      </Section>

      <Section className="border-t border-ink-600 py-16 md:py-20">
        <SectionHead title="How we work" description="Four principles that shape every engagement, regardless of size." />
        <div className="mt-10 grid grid-cols-1 gap-5 sm:grid-cols-2">
          {values.map((value) => (
            <div key={value.title} className="hairline rounded-lg bg-ink-800 p-7">
              <h3 className="font-display text-[17px] font-medium text-ink-50">{value.title}</h3>
              <p className="mt-2.5 text-[14.5px] leading-relaxed text-ink-300">{value.body}</p>
            </div>
          ))}
        </div>
      </Section>

      <Section className="border-t border-ink-600 py-16 md:py-20">
        <SectionHead title="Compliance & standards" />
        <div className="mt-8 grid grid-cols-1 gap-5 sm:grid-cols-3">
          {[
            { badge: "ISO 9001:2015", note: "Quality management systems" },
            { badge: "ISO 27001:2022", note: "Information security management" },
            { badge: "GDPR", note: "Data protection alignment" },
          ].map((item) => (
            <div key={item.badge} className="hairline rounded-lg p-6">
              <p className="font-display text-[16px] font-medium text-brass">{item.badge}</p>
              <p className="mt-2 text-[13.5px] text-ink-300">{item.note}</p>
            </div>
          ))}
        </div>
      </Section>

      <Section className="border-t border-ink-600 py-16 text-center md:py-20">
        <h2 className="font-display text-[28px] font-medium text-ink-50 md:text-[34px]">
          Want to see how we'd approach your project?
        </h2>
        <Link
          href="/contact"
          className="mt-7 inline-block rounded-sm bg-brass px-6 py-3 text-[14px] font-medium text-ink-900 transition-opacity hover:opacity-90"
        >
          Get in touch
        </Link>
      </Section>
    </>
  );
}
