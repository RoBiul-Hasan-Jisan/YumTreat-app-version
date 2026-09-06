import { ReactNode } from "react";

export function Section({
  children,
  className = "",
  id,
}: {
  children: ReactNode;
  className?: string;
  id?: string;
}) {
  return (
    <section id={id} className={`mx-auto max-w-content px-6 py-20 md:py-28 ${className}`}>
      {children}
    </section>
  );
}

export function SectionHead({
  title,
  description,
  align = "left",
}: {
  title: string;
  description?: string;
  align?: "left" | "center";
}) {
  return (
    <div className={`max-w-2xl ${align === "center" ? "mx-auto text-center" : ""}`}>
      <h2 className="font-display text-[32px] font-medium leading-[1.15] tracking-tight text-ink-50 text-balance md:text-[40px]">
        {title}
      </h2>
      {description && (
        <p className="mt-4 text-[16px] leading-relaxed text-ink-300">{description}</p>
      )}
    </div>
  );
}
