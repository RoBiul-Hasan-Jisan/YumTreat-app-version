import type { Metadata } from "next";
import { Section, SectionHead } from "@/components/Section";
import IndustriesGrid from "@/components/IndustriesGrid";

export const metadata: Metadata = {
  title: "Industries",
  description: "Software built for startups, enterprise, healthcare, logistics, govtech, fintech, e-commerce, and EdTech.",
};

export default function IndustriesPage() {
  return (
    <Section className="pb-24 pt-16 md:pt-20">
      <SectionHead
        title="Industries we build for"
        description="Every sector has different constraints — regulatory, operational, or technical. Our process adapts to each one; our quality bar doesn't move."
      />
      <div className="mt-10">
        <IndustriesGrid />
      </div>
    </Section>
  );
}
