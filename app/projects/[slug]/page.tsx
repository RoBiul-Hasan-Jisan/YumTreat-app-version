import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Section } from "@/components/Section";
import ProjectMockup from "@/components/ProjectMockup";
import { projects } from "@/lib/data";

const variantMap: Record<string, "claims" | "market" | "atlas" | "clarive" | "lumen"> = {
  "meridian-claims": "claims",
  "norvale-market": "market",
  atlasboard: "atlas",
  "clarive-health": "clarive",
  "ferro-erp": "atlas",
  "lumen-copilot": "lumen",
};

export function generateStaticParams() {
  return projects.map((p) => ({ slug: p.slug }));
}

export function generateMetadata({ params }: { params: { slug: string } }): Metadata {
  const project = projects.find((p) => p.slug === params.slug);
  if (!project) return {};
  return {
    title: project.name,
    description: project.summary,
  };
}

export default function ProjectPage({ params }: { params: { slug: string } }) {
  const project = projects.find((p) => p.slug === params.slug);
  if (!project) notFound();

  return (
    <Section className="pb-24 pt-16 md:pt-20">
      <Link href="/projects" className="text-[13.5px] text-ink-400 hover:text-brass">
        ← All projects
      </Link>

      <div className="mt-6 grid grid-cols-1 gap-12 lg:grid-cols-[1fr_1fr]">
        <div>
          <span className="text-[13px] text-brass">{project.category}</span>
          <h1 className="mt-2 font-display text-[34px] font-medium leading-tight text-ink-50 text-balance md:text-[42px]">
            {project.name}
          </h1>
          <p className="mt-5 text-[16px] leading-relaxed text-ink-300">{project.summary}</p>

          <div className="mt-8 hairline rounded-lg bg-ink-800 p-6">
            <p className="text-[12px] text-ink-400">Outcome</p>
            <p className="mt-2 text-[15px] font-medium text-ink-50">{project.outcome}</p>
          </div>

          <div className="mt-6">
            <p className="text-[12px] text-ink-400">Stack</p>
            <div className="mt-3 flex flex-wrap gap-2">
              {project.stack.map((tech) => (
                <span key={tech} className="hairline rounded-sm px-3 py-1.5 text-[13px] text-ink-200">
                  {tech}
                </span>
              ))}
            </div>
          </div>
        </div>

        <div className="hairline aspect-[16/10] overflow-hidden rounded-lg bg-ink-800">
          <ProjectMockup variant={variantMap[project.slug] ?? "claims"} />
        </div>
      </div>

      <div className="mt-16 border-t border-ink-600 pt-10 text-center">
        <p className="text-[15px] text-ink-300">Have something similar in mind?</p>
        <Link
          href="/contact"
          className="mt-5 inline-block rounded-sm bg-brass px-6 py-3 text-[14px] font-medium text-ink-900 transition-opacity hover:opacity-90"
        >
          Start a project
        </Link>
      </div>
    </Section>
  );
}
