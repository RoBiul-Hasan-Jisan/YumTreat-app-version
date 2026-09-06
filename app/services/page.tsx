import type { Metadata } from "next";
import Link from "next/link";
import { Section, SectionHead } from "@/components/Section";
import { services } from "@/lib/data";

export const metadata: Metadata = {
  title: "Services",
  description:
    "Advanced web applications, AI systems, security & compliance, custom software, cloud infrastructure, resource augmentation, and enterprise ERP/CRM — delivered by senior engineers.",
};

export default function ServicesPage() {
  return (
    <>
      <Section className="pb-10 pt-16 md:pt-20">
        <SectionHead
          title="Services"
          description="Eight capabilities. One senior team behind every one of them, whether engaged individually or combined into a single build."
        />
      </Section>

      <Section className="border-t border-ink-600 py-0">
        <div className="divide-y divide-ink-600 border-t border-ink-600">
          {services.map((service, i) => (
            <div key={service.slug} id={service.slug} className="scroll-mt-24 py-12 md:py-16">
              <div className="grid grid-cols-1 gap-8 lg:grid-cols-[0.6fr_1fr]">
                <div>
                  <span className="text-[13px] text-ink-500">{String(i + 1).padStart(2, "0")}</span>
                  <h2 className="mt-2 font-display text-[26px] font-medium leading-tight text-ink-50 text-balance md:text-[30px]">
                    {service.name}
                  </h2>
                </div>
                <div>
                  <p className="text-[15.5px] leading-relaxed text-ink-300">{service.description}</p>
                  <ul className="mt-6 space-y-3">
                    {service.bullets.map((bullet) => (
                      <li key={bullet} className="flex items-start gap-3 text-[14.5px] text-ink-200">
                        <span className="mt-2 h-1.5 w-1.5 shrink-0 rounded-full bg-brass" />
                        {bullet}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </div>
          ))}
        </div>
      </Section>

      <Section className="border-t border-ink-600 py-16 text-center md:py-20">
        <h2 className="font-display text-[28px] font-medium text-ink-50 md:text-[34px]">
          Not sure which service fits?
        </h2>
        <p className="mx-auto mt-3 max-w-md text-[15px] text-ink-300">
          Tell us what you're building — we'll tell you what it actually takes.
        </p>
        <Link
          href="/contact"
          className="mt-7 inline-block rounded-sm bg-brass px-6 py-3 text-[14px] font-medium text-ink-900 transition-opacity hover:opacity-90"
        >
          Talk to us
        </Link>
      </Section>
    </>
  );
}
