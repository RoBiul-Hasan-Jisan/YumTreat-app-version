import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { Section } from "@/components/Section";
import { posts } from "@/lib/blog";

export function generateStaticParams() {
  return posts.map((p) => ({ slug: p.slug }));
}

export function generateMetadata({ params }: { params: { slug: string } }): Metadata {
  const post = posts.find((p) => p.slug === params.slug);
  if (!post) return {};
  return { title: post.title, description: post.excerpt };
}

export default function BlogPostPage({ params }: { params: { slug: string } }) {
  const post = posts.find((p) => p.slug === params.slug);
  if (!post) notFound();

  return (
    <Section className="pb-24 pt-16 md:pt-20">
      <div className="mx-auto max-w-[680px]">
        <Link href="/blog" className="text-[13.5px] text-ink-400 hover:text-brass">
          ← Blog
        </Link>
        <div className="mt-6 flex items-center gap-3 text-[12.5px] text-ink-400">
          <span className="text-brass">{post.category}</span>
          <span>·</span>
          <span>{post.readTime}</span>
          <span>·</span>
          <span>
            {new Date(post.date).toLocaleDateString("en-US", { month: "long", day: "numeric", year: "numeric" })}
          </span>
        </div>
        <h1 className="mt-3 font-display text-[32px] font-medium leading-tight text-ink-50 text-balance md:text-[40px]">
          {post.title}
        </h1>
        <div className="mt-8 space-y-5 text-[16px] leading-relaxed text-ink-200">
          {post.content.map((para, i) => (
            <p key={i}>{para}</p>
          ))}
        </div>
      </div>
    </Section>
  );
}
