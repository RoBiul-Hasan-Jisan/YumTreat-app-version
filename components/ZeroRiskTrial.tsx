const steps = [
  {
    title: "No upfront cost",
    body: "We start work before any invoice is raised. You see real output first.",
  },
  {
    title: "Full integration",
    body: "The engineer joins your repo, your standup, and your tools for 8 working hours.",
  },
  {
    title: "Zero-risk exit",
    body: "Not a fit? Walk away with no charge and no explanation required.",
  },
];

export default function ZeroRiskTrial() {
  return (
    <div className="grid grid-cols-1 gap-14 lg:grid-cols-2 lg:items-center">
      <div>
        <ol className="space-y-8 border-l border-ink-600 pl-7">
          {steps.map((step, i) => (
            <li key={step.title} className="relative">
              <span className="absolute -left-[31px] top-0.5 flex h-4 w-4 items-center justify-center rounded-full border border-brass bg-ink-900 text-[10px] text-brass">
                {i + 1}
              </span>
              <h3 className="font-display text-[17px] font-medium text-ink-50">{step.title}</h3>
              <p className="mt-1.5 text-[14px] leading-relaxed text-ink-300">{step.body}</p>
            </li>
          ))}
        </ol>
      </div>

      <div className="hairline rounded-lg bg-ink-800 p-5">
        <div className="flex items-center justify-between border-b border-ink-600 pb-3">
          <span className="text-[13px] text-ink-300">Trial · Task Board</span>
          <span className="text-[11px] text-brass">Day 1 of 1 · 8h</span>
        </div>
        <div className="mt-4 grid grid-cols-3 gap-3">
          {[
            { label: "To do", items: ["Env access", "Repo walkthrough"] },
            { label: "In progress", items: ["Auth module fix"] },
            { label: "Done", items: ["Onboarding call", "CI passing"] },
          ].map((col) => (
            <div key={col.label}>
              <p className="text-[11px] text-ink-400">{col.label}</p>
              <div className="mt-2 space-y-2">
                {col.items.map((item) => (
                  <div key={item} className="hairline rounded-sm bg-ink-900 px-2.5 py-2 text-[11.5px] text-ink-200">
                    {item}
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
        <div className="mt-5 border-t border-ink-600 pt-4">
          <div className="flex items-center justify-between text-[12px] text-ink-300">
            <span>Hours logged</span>
            <span className="text-ink-50">6.5 / 8.0</span>
          </div>
          <div className="mt-2 h-1.5 w-full overflow-hidden rounded-full bg-ink-600">
            <div className="h-full rounded-full bg-brass" style={{ width: "81%" }} />
          </div>
        </div>
      </div>
    </div>
  );
}
