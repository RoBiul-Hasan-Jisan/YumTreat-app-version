import type { Metadata } from "next";
import Link from "next/link";
import { Section, SectionHead } from "@/components/Section";

export const metadata: Metadata = {
  title: "Careers",
  description: "Open roles at Pleron Labs for senior engineers who want to work on production systems, not prototypes.",
};

const openings = [
  { role: "Senior Full-Stack Engineer", type: "Full-time · Remote", team: "Product Engineering" },
  { role: "AI/ML Engineer", type: "Full-time · Remote", team: "AI Systems" },
  { role: "DevOps / Cloud Engineer", type: "Full-time · Remote", team: "Infrastructure" },
  { role: "Technical Project Lead", type: "Full-time · Chattogram or Remote", team: "Delivery" },
];

const perks = [
  { title: "Senior-only teams", body: "You'll work alongside engineers who've shipped production systems before, not juniors you're mentoring by default." },
  { title: "Real ownership", body: "Technical leads own delivery end to end — architecture calls aren't made by someone three layers removed from the code." },
  { title: "International client exposure", body: "You'll work directly with clients across the Middle East, Europe, and North America, not through a layer of account managers." },
  { title: "No bench time", body: "Every hire is matched to active work before they join — we don't hire ahead of demand." },
];

export default function CareersPage() {
  return (
    <>
      <Section className="pb-16 pt-16 md:pt-20">
        <SectionHead
          title="Careers"
          description="We hire senior engineers only — people who've already shipped production software and want to keep doing it, without the overhead of a bigger company."
        />
      </Section>

      <Section className="border-t border-ink-600 py-16 md:py-20">
        <SectionHead title="Why engineers stay" />
        <div className="mt-10 grid grid-cols-1 gap-5 sm:grid-cols-2">
          {perks.map((perk) => (
            <div key={perk.title} className="hairline rounded-lg bg-ink-800 p-7">
              <h3 className="font-display text-[16px] font-medium text-ink-50">{perk.title}</h3>
              <p className="mt-2.5 text-[14px] leading-relaxed text-ink-300">{perk.body}</p>
            </div>
          ))}
        </div>
      </Section>

      <Section className="border-t border-ink-600 py-16 md:py-20">
        <SectionHead title="Open roles" />
        <div className="mt-8 divide-y divide-ink-600 border-t border-ink-600">
          {openings.map((job) => (
            <div key={job.role} className="flex flex-col gap-2 py-6 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <h3 className="font-display text-[16.5px] font-medium text-ink-50">{job.role}</h3>
                <p className="mt-1 text-[13.5px] text-ink-300">{job.team} · {job.type}</p>
              </div>
              <Link
                href="/contact"
                className="w-fit rounded-sm border border-ink-600 px-4 py-2 text-[13.5px] text-ink-100 transition-colors hover:border-brass/60 hover:text-brass"
              >
                Apply
              </Link>
            </div>
          ))}
        </div>
        <p className="mt-8 text-[13.5px] text-ink-400">
          Don't see a fit but think you should be on the team anyway?{" "}
          <Link href="/contact" className="text-brass hover:opacity-80">Reach out</Link> — we read every message.
        </p>
      </Section>
    </>
  );
}
