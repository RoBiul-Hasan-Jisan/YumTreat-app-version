import type { Metadata } from "next";
import { Section, SectionHead } from "@/components/Section";
import FeaturedProjects from "@/components/FeaturedProjects";

export const metadata: Metadata = {
  title: "Projects",
  description: "Case studies from platforms Pleron Labs has designed, built, and shipped across sectors.",
};

export default function ProjectsPage() {
  return (
    <Section className="pb-24 pt-16 md:pt-20">
      <SectionHead
        title="Projects"
        description="Six representative builds — service platforms, e-commerce, admin tooling, healthcare, ERP, and AI systems."
      />
      <div className="mt-10">
        <FeaturedProjects />
      </div>
    </Section>
  );
}
