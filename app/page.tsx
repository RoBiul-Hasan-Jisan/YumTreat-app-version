import Link from "next/link";
import { Section, SectionHead } from "@/components/Section";
import HeroCarousel from "@/components/HeroCarousel";
import RotatingWord from "@/components/RotatingWord";
import StatsRow from "@/components/StatsRow";
import ServicesGrid from "@/components/ServicesGrid";
import FeaturedProjects from "@/components/FeaturedProjects";
import IndustriesGrid from "@/components/IndustriesGrid";
import ZeroRiskTrial from "@/components/ZeroRiskTrial";
import EngagementModels from "@/components/EngagementModels";

export default function Home() {
  return (
    <>
      {/* Hero */}
      <Section className="pb-16 pt-14 md:pb-20 md:pt-20">
        <div className="grid grid-cols-1 gap-14 lg:grid-cols-[1.05fr_1fr] lg:items-center">
          <div className="animate-fade-up">
            <h1 className="font-display text-[38px] font-medium leading-[1.12] tracking-tight text-ink-50 text-balance sm:text-[48px] lg:text-[54px]">
              Turning <RotatingWord words={["Complex", "Ambitious", "Unstructured"]} /> Ideas Into{" "}
              <RotatingWord words={["Exceptional", "Reliable", "Scalable"]} delay={1400} /> Software
            </h1>
            <p className="mt-6 max-w-lg text-[16.5px] leading-relaxed text-ink-300">
              We build web, mobile, and AI-powered software — custom or ready-made — for businesses
              across every sector. Delivered by senior engineers to Middle East, European, and North
              American clients.
            </p>
            <div className="mt-9 flex flex-wrap items-center gap-4">
              <Link
                href="/contact"
                className="rounded-sm bg-brass px-6 py-3 text-[14px] font-medium text-ink-900 transition-opacity hover:opacity-90"
              >
                Start a project
              </Link>
              <Link
                href="/projects"
                className="rounded-sm border border-ink-600 px-6 py-3 text-[14px] text-ink-100 transition-colors hover:border-brass/60"
              >
                View our work
              </Link>
            </div>
          </div>
          <HeroCarousel />
        </div>
      </Section>

      {/* Why Us */}
      <Section className="border-t border-ink-600 py-16 md:py-20">
        <div className="grid grid-cols-1 gap-10 lg:grid-cols-[0.8fr_1fr]">
          <SectionHead title="Why we exist" />
          <div className="space-y-5 text-[15.5px] leading-relaxed text-ink-300">
            <p>
              We founded Pleron Labs on a simple observation: too many software projects fail not
              because of technical limitations, but because of fragmented execution, poor
              communication, and design treated as an afterthought.
            </p>
            <p>
              So we built the opposite kind of company — one senior team, one point of accountability,
              and a process that treats architecture and interface design as decisions made on day one,
              not patched in after launch. Every engagement runs on the same discipline, whether it's an
              8-hour trial or a year-long build.
            </p>
          </div>
        </div>
      </Section>

      {/* What Sets Us Apart */}
      <Section className="border-t border-ink-600 py-16 md:py-20">
        <SectionHead
          title="What sets us apart"
          description="The details that determine whether a software partner is dependable at scale."
        />
        <div className="mt-10">
          <StatsRow />
        </div>
      </Section>

      {/* The Bottleneck */}
      <Section className="border-t border-ink-600 py-16 md:py-20">
        <div className="grid grid-cols-1 gap-12 lg:grid-cols-2 lg:items-center">
          <div>
            <h2 className="font-display text-[32px] font-medium leading-[1.15] tracking-tight text-ink-50 text-balance md:text-[40px]">
              What&apos;s stopping your product from shipping?
            </h2>
            <p className="mt-5 text-[15.5px] leading-relaxed text-ink-300">
              Most stalled projects aren&apos;t stuck on a hard technical problem — they&apos;re stuck
              on unclear ownership, an under-resourced team, or an architecture that can&apos;t take
              the next feature without breaking. We step in as senior engineers, not consultants,
              and get the codebase moving again.
            </p>
            <Link
              href="/contact"
              className="mt-7 inline-block rounded-sm border border-brass/60 px-5 py-2.5 text-[14px] text-brass transition-colors hover:bg-brass hover:text-ink-900"
            >
              Tell us where you're stuck
            </Link>
          </div>
          <div className="hairline space-y-px overflow-hidden rounded-lg bg-ink-600">
            {[
              { issue: "Unclear technical ownership", fix: "One senior lead accountable end to end" },
              { issue: "Architecture can't take new features", fix: "Refactor plan scoped before new work starts" },
              { issue: "Team under-resourced for the deadline", fix: "Senior engineers embedded within days" },
              { issue: "No visibility into progress", fix: "Weekly demos against a shared roadmap" },
            ].map((row) => (
              <div key={row.issue} className="grid grid-cols-[1fr_auto_1fr] items-center gap-4 bg-ink-900 px-5 py-4">
                <span className="text-[13.5px] text-ink-300">{row.issue}</span>
                <span className="text-ink-500">→</span>
                <span className="text-[13.5px] text-ink-50">{row.fix}</span>
              </div>
            ))}
          </div>
        </div>
      </Section>

      {/* Featured Projects */}
      <Section className="border-t border-ink-600 py-16 md:py-20">
        <div className="flex flex-col items-start justify-between gap-6 sm:flex-row sm:items-end">
          <SectionHead
            title="Selected work"
            description="A sample of platforms we've designed, built, and shipped for clients across sectors."
          />
          <Link href="/projects" className="whitespace-nowrap text-[14px] text-brass hover:opacity-80">
            View all projects →
          </Link>
        </div>
        <div className="mt-10">
          <FeaturedProjects />
        </div>
      </Section>

      {/* Services */}
      <Section className="border-t border-ink-600 py-16 md:py-20">
        <SectionHead
          title="Services"
          description="Eight capabilities, one senior team — engaged individually or combined into a full build."
        />
        <div className="mt-10">
          <ServicesGrid />
        </div>
      </Section>

      {/* White Label */}
      <Section className="border-t border-ink-600 py-16 md:py-20">
        <div className="hairline overflow-hidden rounded-lg bg-ink-800">
          <div className="grid grid-cols-1 lg:grid-cols-[1fr_1fr]">
            <div className="p-8 md:p-12">
              <h2 className="font-display text-[28px] font-medium leading-tight text-ink-50 text-balance md:text-[34px]">
                Your invisible tech force. We build it, you brand it.
              </h2>
              <p className="mt-5 text-[15px] leading-relaxed text-ink-300">
                Agencies and consultancies bring us in as their delivery team. Your clients only ever
                see your brand, your account manager, and your invoice.
              </p>
              <Link
                href="/contact"
                className="mt-7 inline-block rounded-sm bg-brass px-6 py-3 text-[14px] font-medium text-ink-900 transition-opacity hover:opacity-90"
              >
                Partner with us
              </Link>
            </div>
            <div className="grid grid-cols-1 gap-px bg-ink-600 sm:grid-cols-3 lg:border-l lg:border-ink-600">
              {[
                { title: "100% Anonymous", body: "No Pleron branding in any client-facing deliverable." },
                { title: "NDA & Client Protection", body: "Signed NDAs and non-solicitation as standard practice." },
                { title: "On-Demand Scaling", body: "Add or release engineers as your pipeline shifts." },
              ].map((pillar) => (
                <div key={pillar.title} className="bg-ink-800 p-6">
                  <h3 className="text-[14.5px] font-medium text-ink-50">{pillar.title}</h3>
                  <p className="mt-2 text-[13px] leading-relaxed text-ink-300">{pillar.body}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </Section>

      {/* Industries */}
      <Section className="border-t border-ink-600 py-16 md:py-20">
        <SectionHead
          title="Industries we build for"
          description="Every sector has different constraints. Our process adapts — our quality bar doesn't."
        />
        <div className="mt-10">
          <IndustriesGrid />
        </div>
      </Section>

      {/* Zero Risk Trial */}
      <Section className="border-t border-ink-600 py-16 md:py-20">
        <SectionHead
          title="Not convinced? Test us."
          description="An 8-hour trial engagement, at absolute zero risk, before you commit to anything larger."
        />
        <div className="mt-10">
          <ZeroRiskTrial />
        </div>
        <Link
          href="/contact"
          className="mt-10 inline-block rounded-sm bg-brass px-6 py-3 text-[14px] font-medium text-ink-900 transition-opacity hover:opacity-90"
        >
          Start risk-free trial
        </Link>
      </Section>

      {/* Engagement Models */}
      <Section className="border-t border-ink-600 py-16 md:py-20">
        <SectionHead
          title="Engagement models"
          description="Choose the structure that fits how your team already operates."
        />
        <div className="mt-10">
          <EngagementModels />
        </div>
      </Section>

      {/* Final CTA */}
      <Section className="border-t border-ink-600 py-20 text-center md:py-28">
        <h2 className="font-display text-[34px] font-medium leading-[1.15] tracking-tight text-ink-50 text-balance md:text-[46px]">
          Have an idea? Tell us.
        </h2>
        <p className="mx-auto mt-4 max-w-md text-[15.5px] leading-relaxed text-ink-300">
          A short call is usually enough for us to tell you whether it's a fit — and if it is, what
          shipping it would actually take.
        </p>
        <Link
          href="/contact"
          className="mt-8 inline-block rounded-sm bg-brass px-7 py-3.5 text-[14.5px] font-medium text-ink-900 transition-opacity hover:opacity-90"
        >
          Get in touch
        </Link>
      </Section>
    </>
  );
}
