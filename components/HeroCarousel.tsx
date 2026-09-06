"use client";

import { useEffect, useState } from "react";
import ProjectMockup from "./ProjectMockup";

const slides: { variant: "claims" | "market" | "atlas" | "clarive" | "lumen"; label: string }[] = [
  { variant: "claims", label: "Meridian Claims — Service Platform" },
  { variant: "market", label: "Norvale Market — E-Commerce" },
  { variant: "atlas", label: "AtlasBoard — Admin Panel" },
  { variant: "clarive", label: "Clarive Health — Healthcare Platform" },
  { variant: "lumen", label: "Lumen Copilot — AI System" },
];

export default function HeroCarousel() {
  const [active, setActive] = useState(0);

  useEffect(() => {
    const t = setInterval(() => {
      setActive((prev) => (prev + 1) % slides.length);
    }, 3400);
    return () => clearInterval(t);
  }, []);

  return (
    <div className="relative">
      <div className="hairline relative aspect-[16/10] w-full overflow-hidden rounded-lg bg-ink-800">
        {slides.map((slide, i) => (
          <div
            key={slide.variant}
            className="absolute inset-0 transition-opacity duration-700 ease-out"
            style={{ opacity: active === i ? 1 : 0 }}
            aria-hidden={active !== i}
          >
            <ProjectMockup variant={slide.variant} />
          </div>
        ))}
      </div>
      <div className="mt-4 flex items-center justify-between">
        <p className="text-[13px] text-ink-300">{slides[active].label}</p>
        <div className="flex gap-1.5">
          {slides.map((slide, i) => (
            <button
              key={slide.variant}
              onClick={() => setActive(i)}
              aria-label={`Show ${slide.label}`}
              className="h-1.5 rounded-full transition-all"
              style={{
                width: active === i ? "20px" : "6px",
                background: active === i ? "#C9A15A" : "#3A3E45",
              }}
            />
          ))}
        </div>
      </div>
    </div>
  );
}
