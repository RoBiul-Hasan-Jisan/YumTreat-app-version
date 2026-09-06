import Link from "next/link";
import ProjectMockup from "./ProjectMockup";
import { projects } from "@/lib/data";

const variants = ["claims", "market", "atlas", "clarive", "lumen", "claims"] as const;

export default function FeaturedProjects() {
  return (
    <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
      {projects.map((project, i) => (
        <Link
          key={project.slug}
          href={`/projects/${project.slug}`}
          className="hairline group overflow-hidden rounded-lg bg-ink-800 transition-transform hover:-translate-y-1"
        >
          <div className="aspect-[16/10] overflow-hidden border-b border-ink-600">
            <ProjectMockup variant={variants[i]} />
          </div>
          <div className="p-5">
            <span className="text-[12px] text-brass">{project.category}</span>
            <h3 className="mt-1.5 font-display text-[17px] font-medium text-ink-50">{project.name}</h3>
            <p className="mt-2 text-[13.5px] leading-relaxed text-ink-300">{project.summary}</p>
          </div>
        </Link>
      ))}
    </div>
  );
}
