import Link from "next/link";

const sitemap = [
  { label: "Services", href: "/services" },
  { label: "Projects", href: "/projects" },
  { label: "Industries", href: "/industries" },
  { label: "Company", href: "/company" },
  { label: "Blog", href: "/blog" },
  { label: "Careers", href: "/careers" },
  { label: "Contact", href: "/contact" },
];

const socials = [
  { label: "LinkedIn", href: "https://linkedin.com" },
  { label: "GitHub", href: "https://github.com" },
  { label: "Facebook", href: "https://facebook.com" },
  { label: "Messenger", href: "https://m.me" },
  { label: "WhatsApp", href: "https://wa.me" },
  { label: "Calendly", href: "https://calendly.com" },
];

export default function Footer() {
  return (
    <footer className="border-t border-ink-600 bg-ink-900">
      <div className="mx-auto max-w-content px-6 py-16">
        <div className="grid grid-cols-1 gap-12 md:grid-cols-[1.3fr_1fr_1fr_1fr]">
          <div>
            <span className="font-display text-[18px] font-medium text-ink-50">
              Pleron <span className="text-ink-300">Labs</span>
            </span>
            <p className="mt-4 max-w-xs text-[14px] leading-relaxed text-ink-300">
              We build web, mobile, and AI-powered software for businesses across every sector —
              engineered to international standards, delivered by senior engineers only.
            </p>
            <div className="mt-6 space-y-1 text-[13px] text-ink-300">
              <p>Chattogram, Bangladesh</p>
              <p>
                <a href="mailto:hello@pleronlabs.com" className="hover:text-brass">
                  hello@pleronlabs.com
                </a>
              </p>
            </div>
          </div>

          <div>
            <p className="text-[13px] text-ink-400">Sitemap</p>
            <ul className="mt-4 space-y-2.5">
              {sitemap.map((item) => (
                <li key={item.href}>
                  <Link href={item.href} className="text-[14px] text-ink-200 hover:text-brass">
                    {item.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <p className="text-[13px] text-ink-400">Connect</p>
            <ul className="mt-4 space-y-2.5">
              {socials.map((item) => (
                <li key={item.label}>
                  <a
                    href={item.href}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-[14px] text-ink-200 hover:text-brass"
                  >
                    {item.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <p className="text-[13px] text-ink-400">Compliance</p>
            <ul className="mt-4 space-y-2.5 text-[13px] text-ink-300">
              <li className="hairline rounded-sm px-3 py-2">ISO 9001:2015</li>
              <li className="hairline rounded-sm px-3 py-2">ISO 27001:2022</li>
              <li className="hairline rounded-sm px-3 py-2">GDPR Aligned</li>
            </ul>
          </div>
        </div>

        <div className="mt-14 flex flex-col gap-4 border-t border-ink-600 pt-8 text-[13px] text-ink-400 md:flex-row md:items-center md:justify-between">
          <p>© {new Date().getFullYear()} Pleron Labs. All rights reserved.</p>
          <div className="flex flex-wrap gap-x-6 gap-y-2">
            <Link href="/terms" className="hover:text-brass">Terms</Link>
            <Link href="/privacy" className="hover:text-brass">Privacy</Link>
            <p className="max-w-md text-ink-500">
              Client logos and designs shown are for illustrative purposes; trademarks belong to their respective owners.
            </p>
          </div>
        </div>
      </div>
    </footer>
  );
}
