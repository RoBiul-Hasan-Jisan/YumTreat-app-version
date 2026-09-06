type Variant = "claims" | "market" | "atlas" | "clarive" | "lumen";

const palette = {
  claims: { a: "#C9A15A", b: "#3A3E45" },
  market: { a: "#6B87FF", b: "#3A3E45" },
  atlas: { a: "#7FB8A0", b: "#3A3E45" },
  clarive: { a: "#E4A6A6", b: "#3A3E45" },
  lumen: { a: "#C9A15A", b: "#6B87FF" },
};

export default function ProjectMockup({ variant }: { variant: Variant }) {
  const c = palette[variant];
  return (
    <svg viewBox="0 0 640 400" className="h-full w-full" xmlns="http://www.w3.org/2000/svg">
      <rect width="640" height="400" fill="#16181C" />
      <rect x="0" y="0" width="640" height="36" fill="#1B1D22" />
      <circle cx="20" cy="18" r="4" fill="#3A3E45" />
      <circle cx="34" cy="18" r="4" fill="#3A3E45" />
      <circle cx="48" cy="18" r="4" fill="#3A3E45" />
      <rect x="200" y="10" width="240" height="16" rx="4" fill="#232930" />

      {/* sidebar */}
      <rect x="0" y="36" width="120" height="364" fill="#131519" />
      {[70, 100, 130, 160, 190].map((y, i) => (
        <rect key={y} x="20" y={y} width={i === 0 ? 80 : 70} height="10" rx="3" fill={i === 0 ? c.a : "#2C3038"} opacity={i === 0 ? 1 : 0.7} />
      ))}

      {/* top stat row */}
      {[0, 1, 2].map((i) => (
        <g key={i}>
          <rect x={140 + i * 168} y="56" width="150" height="72" rx="6" fill="#1B1D22" stroke="#262930" />
          <rect x={156 + i * 168} y="72" width="50" height="8" rx="2" fill="#5C616B" />
          <rect x={156 + i * 168} y="92" width="80" height="18" rx="3" fill={i === 1 ? c.a : "#E7E8EA"} opacity={i === 1 ? 1 : 0.9} />
        </g>
      ))}

      {/* main chart panel */}
      <rect x="140" y="148" width="480" height="150" rx="6" fill="#1B1D22" stroke="#262930" />
      <polyline
        points="160,260 210,230 260,245 310,200 360,215 410,175 460,190 510,150 560,165 600,140"
        fill="none"
        stroke={c.a}
        strokeWidth="2.5"
      />
      <polyline
        points="160,270 210,265 260,255 310,250 360,240 410,235 460,220 510,215 560,205 600,195"
        fill="none"
        stroke={c.b}
        strokeWidth="2"
        opacity="0.6"
      />

      {/* table rows */}
      {[0, 1, 2, 3].map((i) => (
        <g key={i}>
          <rect x="140" y={316 + i * 20} width="480" height="14" rx="3" fill="#1B1D22" />
          <rect x="150" y={320 + i * 20} width="120" height="6" rx="2" fill="#5C616B" />
          <rect x="450" y={320 + i * 20} width="60" height="6" rx="2" fill={i === 0 ? c.a : "#3A3E45"} />
        </g>
      ))}
    </svg>
  );
}
