import type { Metadata } from "next";
import Link from "next/link";
import { Section, SectionHead } from "@/components/Section";
import { posts } from "@/lib/blog";

export const metadata: Metadata = {
  title: "Blog",
  description: "Notes on engineering, AI systems, and running software projects that ship.",
};

export default function BlogPage() {
  return (
    <Section className="pb-24 pt-16 md:pt-20">
      <SectionHead title="Blog" description="Notes on engineering, AI systems, and running projects that actually ship." />
      <div className="mt-10 divide-y divide-ink-600 border-t border-ink-600">
        {posts.map((post) => (
          <Link
            key={post.slug}
            href={`/blog/${post.slug}`}
            className="group flex flex-col gap-2 py-8 sm:flex-row sm:items-baseline sm:justify-between sm:gap-8"
          >
            <div className="sm:max-w-xl">
              <div className="flex items-center gap-3 text-[12.5px] text-ink-400">
                <span className="text-brass">{post.category}</span>
                <span>·</span>
                <span>{post.readTime}</span>
              </div>
              <h2 className="mt-2 font-display text-[19px] font-medium text-ink-50 group-hover:text-brass">
                {post.title}
              </h2>
              <p className="mt-2 text-[14px] leading-relaxed text-ink-300">{post.excerpt}</p>
            </div>
            <span className="whitespace-nowrap text-[13px] text-ink-500">
              {new Date(post.date).toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" })}
            </span>
          </Link>
        ))}
      </div>
    </Section>
  );
}
