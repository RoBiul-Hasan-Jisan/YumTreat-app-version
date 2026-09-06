"use client";

import { useState } from "react";

const models = [
  {
    key: "augmentation",
    label: "Staff Augmentation",
    description: "Add senior engineers directly into your team, under your management, for as long as you need them.",
    fit: "Best for teams with a technical lead already in place who need more hands.",
    preview: ["1 backend engineer", "2 sprints booked", "Reports to your PM"],
  },
  {
    key: "outsourcing",
    label: "IT Outsourcing",
    description: "Hand us a scope and outcome. We staff, manage, and deliver the full project ourselves.",
    fit: "Best for teams without in-house technical leadership for this project.",
    preview: ["Full delivery team", "Fixed milestones", "Weekly demo cadence"],
  },
  {
    key: "fixed",
    label: "Fixed Budget",
    description: "A defined scope, timeline, and price agreed before work starts — no surprises at invoice time.",
    fit: "Best for well-defined projects with a hard budget ceiling.",
    preview: ["Scope locked", "Price fixed", "Change requests scoped separately"],
  },
];

export default function EngagementModels() {
  const [active, setActive] = useState(models[0].key);
  const model = models.find((m) => m.key === active)!;

  return (
    <div className="hairline rounded-lg bg-ink-800 p-2">
      <div className="flex flex-col gap-1 border-b border-ink-600 p-2 sm:flex-row">
        {models.map((m) => (
          <button
            key={m.key}
            onClick={() => setActive(m.key)}
            className={`flex-1 rounded-sm px-4 py-2.5 text-[14px] transition-colors ${
              active === m.key ? "bg-ink-900 text-ink-50" : "text-ink-300 hover:text-ink-50"
            }`}
          >
            {m.label}
          </button>
        ))}
      </div>

      <div className="grid grid-cols-1 gap-8 p-6 md:grid-cols-[1.2fr_1fr] md:p-8">
        <div>
          <h3 className="font-display text-[20px] font-medium text-ink-50">{model.label}</h3>
          <p className="mt-3 text-[15px] leading-relaxed text-ink-300">{model.description}</p>
          <p className="mt-4 text-[13.5px] text-ink-400">{model.fit}</p>
        </div>
        <div className="hairline rounded-lg bg-ink-900 p-5">
          <p className="text-[12px] text-ink-400">Engagement summary</p>
          <div className="mt-3 space-y-2.5">
            {model.preview.map((line) => (
              <div key={line} className="flex items-center gap-2.5">
                <span className="h-1.5 w-1.5 rounded-full bg-brass" />
                <span className="text-[13.5px] text-ink-200">{line}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
