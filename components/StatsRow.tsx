const avatars = ["#C9A15A", "#6B87FF", "#7FB8A0", "#E4A6A6", "#B9BCC2"];

export default function StatsRow() {
  return (
    <div className="grid grid-cols-1 gap-5 md:grid-cols-3">
      <div className="hairline rounded-lg bg-ink-800 p-7">
        <p className="text-[13px] text-ink-300">Senior engineers only</p>
        <div className="mt-4 flex items-end gap-2">
          <span className="font-display text-[40px] font-medium leading-none text-ink-50">+100%</span>
          <span className="pb-1 text-[13px] text-brass">senior-level trend</span>
        </div>
        <div className="mt-5 flex h-10 items-end gap-1">
          {[22, 30, 26, 38, 34, 46, 42, 56].map((h, i) => (
            <div key={i} className="w-full rounded-t-sm bg-ink-600" style={{ height: `${h}px` }}>
              <div className="h-1 rounded-t-sm bg-brass" style={{ opacity: i > 4 ? 1 : 0 }} />
            </div>
          ))}
        </div>
        <p className="mt-4 text-[13px] leading-relaxed text-ink-300">
          No junior bench. Every engineer on your project has shipped production systems before joining us.
        </p>
      </div>

      <div className="hairline rounded-lg bg-ink-800 p-7">
        <p className="text-[13px] text-ink-300">International standards</p>
        <div className="mt-4 flex flex-wrap gap-2">
          {["ISO 9001:2015", "ISO 27001:2022", "GDPR"].map((badge) => (
            <span key={badge} className="hairline rounded-sm px-2.5 py-1 text-[12px] text-ink-200">
              {badge}
            </span>
          ))}
        </div>
        <div className="mt-6 flex items-center">
          <div className="flex -space-x-2.5">
            {avatars.map((c, i) => (
              <span
                key={i}
                className="h-8 w-8 rounded-full border-2 border-ink-800"
                style={{ background: c }}
              />
            ))}
          </div>
          <span className="ml-3 text-[13px] text-ink-300">+15 active experts</span>
        </div>
        <p className="mt-4 text-[13px] leading-relaxed text-ink-300">
          Delivery processes are built around the same compliance standards enterprise clients audit against.
        </p>
      </div>

      <div className="hairline rounded-lg bg-ink-800 p-7">
        <p className="text-[13px] text-ink-300">Close collaboration</p>
        <div className="mt-4 flex items-center gap-2">
          <span className="relative flex h-2.5 w-2.5">
            <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-brass opacity-60" />
            <span className="relative inline-flex h-2.5 w-2.5 rounded-full bg-brass" />
          </span>
          <span className="font-display text-[20px] font-medium text-ink-50">100% Active</span>
        </div>
        <p className="mt-5 text-[13px] text-ink-300">Chattogram, Bangladesh — working across time zones</p>
        <div className="mt-4 space-y-2">
          {["Middle East", "Europe", "North America"].map((region) => (
            <div key={region} className="flex items-center justify-between text-[13px]">
              <span className="text-ink-200">{region}</span>
              <span className="text-ink-400">overlap daily</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
