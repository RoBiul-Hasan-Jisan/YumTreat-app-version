import Link from "next/link";
import { services } from "@/lib/data";

const icons: Record<string, JSX.Element> = {
  "advanced-web-applications": (
    <path d="M4 6h16v12H4z M4 10h16 M8 14h4" />
  ),
  "white-label-services": <path d="M12 3l8 4-8 4-8-4 8-4z M4 11l8 4 8-4 M4 15l8 4 8-4" />,
  "ai-systems-and-automations": <path d="M12 4v3 M12 17v3 M4 12h3 M17 12h3 M7 7l2 2 M15 15l2 2 M17 7l-2 2 M9 15l-2 2 M12 9a3 3 0 100 6 3 3 0 000-6z" />,
  "security-and-compliance": <path d="M12 3l7 3v6c0 4.5-3 7.5-7 9-4-1.5-7-4.5-7-9V6l7-3z M9.5 12l2 2 3.5-3.5" />,
  "custom-software-development": <path d="M8 6l-5 6 5 6 M16 6l5 6-5 6 M13 4l-2 16" />,
  "cloud-infrastructure": <path d="M7 17a4 4 0 010-8 5 5 0 019.5-1.5A4 4 0 0117 17H7z" />,
  "resource-augmentation": <path d="M9 11a3 3 0 100-6 3 3 0 000 6z M3 20a6 6 0 0112 0 M17 8a3 3 0 110-6 M21 20a5.5 5.5 0 00-5-5.4" />,
  "enterprise-erp-crm": <path d="M4 4h7v7H4z M13 4h7v7h-7z M4 13h7v7H4z M13 13h7v7h-7z" />,
};

export default function ServicesGrid() {
  return (
    <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4">
      {services.map((service) => (
        <Link
          key={service.slug}
          href={`/services#${service.slug}`}
          className="hairline group flex flex-col rounded-lg bg-ink-800 p-6 transition-colors hover:border-brass/50"
        >
          <svg viewBox="0 0 24 24" className="h-7 w-7 text-brass" fill="none" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round" strokeLinejoin="round">
            {icons[service.slug]}
          </svg>
          <h3 className="mt-5 font-display text-[16px] font-medium text-ink-50">{service.name}</h3>
          <p className="mt-2 text-[13.5px] leading-relaxed text-ink-300">{service.short}</p>
          <span className="mt-4 text-[13px] text-ink-400 group-hover:text-brass">Learn more</span>
        </Link>
      ))}
    </div>
  );
}
