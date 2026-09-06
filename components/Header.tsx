"use client";

import Link from "next/link";
import { useState } from "react";
import { usePathname } from "next/navigation";

const nav = [
  { label: "Services", href: "/services" },
  { label: "Projects", href: "/projects" },
  { label: "Industries", href: "/industries" },
  { label: "Company", href: "/company" },
  { label: "Blog", href: "/blog" },
  { label: "Careers", href: "/careers" },
];

export default function Header() {
  const [open, setOpen] = useState(false);
  const pathname = usePathname();

  return (
    <header className="sticky top-0 z-50 border-b border-ink-600/60 bg-ink-900/85 backdrop-blur">
      <div className="mx-auto flex max-w-content items-center justify-between px-6 py-4">
        <Link href="/" className="flex items-center gap-2.5" onClick={() => setOpen(false)}>
          <span className="flex h-7 w-7 items-center justify-center rounded-sm border border-brass/50 text-[13px] font-semibold text-brass">
            P
          </span>
          <span className="font-display text-[17px] font-medium tracking-tight text-ink-50">
            Pleron<span className="text-ink-300"> Labs</span>
          </span>
        </Link>

        <nav className="hidden items-center gap-8 lg:flex">
          {nav.map((item) => {
            const active = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`text-[14px] transition-colors ${
                  active ? "text-ink-50" : "text-ink-300 hover:text-ink-50"
                }`}
              >
                {item.label}
              </Link>
            );
          })}
        </nav>

        <div className="hidden lg:block">
          <Link
            href="/contact"
            className="rounded-sm border border-brass/60 px-4 py-2 text-[14px] text-brass transition-colors hover:bg-brass hover:text-ink-900"
          >
            Start a project
          </Link>
        </div>

        <button
          aria-label="Toggle menu"
          onClick={() => setOpen(!open)}
          className="flex h-9 w-9 items-center justify-center rounded-sm border border-ink-600 lg:hidden"
        >
          <div className="flex flex-col gap-[5px]">
            <span className={`h-px w-4 bg-ink-100 transition-transform ${open ? "translate-y-[3px] rotate-45" : ""}`} />
            <span className={`h-px w-4 bg-ink-100 transition-opacity ${open ? "opacity-0" : ""}`} />
            <span className={`h-px w-4 bg-ink-100 transition-transform ${open ? "-translate-y-[3px] -rotate-45" : ""}`} />
          </div>
        </button>
      </div>

      {open && (
        <div className="border-t border-ink-600 px-6 pb-6 pt-2 lg:hidden">
          <nav className="flex flex-col gap-1">
            {nav.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                onClick={() => setOpen(false)}
                className="rounded-sm px-2 py-3 text-[15px] text-ink-200 hover:bg-ink-800 hover:text-ink-50"
              >
                {item.label}
              </Link>
            ))}
            <Link
              href="/contact"
              onClick={() => setOpen(false)}
              className="mt-2 rounded-sm border border-brass/60 px-4 py-3 text-center text-[14px] text-brass"
            >
              Start a project
            </Link>
          </nav>
        </div>
      )}
    </header>
  );
}
