import type { Metadata } from "next";
import { Section, SectionHead } from "@/components/Section";
import ContactForm from "@/components/ContactForm";

export const metadata: Metadata = {
  title: "Contact",
  description: "Tell Pleron Labs about your project — we reply to every inquiry within one business day.",
};

const channels = [
  { label: "Email", value: "hello@pleronlabs.com", href: "mailto:hello@pleronlabs.com" },
  { label: "Calendly", value: "Book a 20-minute call", href: "https://calendly.com" },
  { label: "WhatsApp", value: "Message us directly", href: "https://wa.me" },
];

export default function ContactPage() {
  return (
    <Section className="pb-24 pt-16 md:pt-20">
      <div className="grid grid-cols-1 gap-14 lg:grid-cols-[0.85fr_1.15fr]">
        <div>
          <SectionHead
            title="Have an idea? Tell us."
            description="A short call is usually enough for us to tell you whether it's a fit, and what shipping it would actually take."
          />
          <div className="mt-10 space-y-4">
            {channels.map((c) => (
              <a
                key={c.label}
                href={c.href}
                target={c.href.startsWith("http") ? "_blank" : undefined}
                rel="noopener noreferrer"
                className="hairline flex items-center justify-between rounded-lg px-5 py-4 transition-colors hover:border-brass/50"
              >
                <span className="text-[13.5px] text-ink-300">{c.label}</span>
                <span className="text-[14px] text-ink-50">{c.value}</span>
              </a>
            ))}
          </div>
          <p className="mt-8 text-[13.5px] text-ink-400">Chattogram, Bangladesh — working daily across the Middle East, Europe, and North America.</p>
        </div>

        <ContactForm />
      </div>
    </Section>
  );
}
