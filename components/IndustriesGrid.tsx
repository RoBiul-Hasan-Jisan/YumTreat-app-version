import { industries } from "@/lib/data";

export default function IndustriesGrid() {
  return (
    <div className="grid grid-cols-1 gap-px overflow-hidden rounded-lg border border-ink-600 bg-ink-600 sm:grid-cols-3">
      {industries.map((industry) => (
        <div key={industry.name} className="bg-ink-900 p-6 transition-colors hover:bg-ink-800">
          <h3 className="font-display text-[16px] font-medium text-ink-50">{industry.name}</h3>
          <p className="mt-2 text-[13.5px] leading-relaxed text-ink-300">{industry.pitch}</p>
        </div>
      ))}
    </div>
  );
}
