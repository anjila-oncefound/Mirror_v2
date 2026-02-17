const segments = [
  {
    label: "Segment 1 — Singapore",
    total: 2040,
    bars: [
      { color: "bg-[#d9d9d9]", value: 1200, label: "Uncontacted" },
      { color: "bg-[#7cb5d9]", value: 480, label: "Contacted" },
      { color: "bg-accent-green", value: 300, label: "Qualified" },
      { color: "bg-accent-red", value: 60, label: "Disqualified" },
    ],
  },
  {
    label: "Segment 2 — Kuala Lumpur",
    total: 1560,
    bars: [
      { color: "bg-[#d9d9d9]", value: 900, label: "Uncontacted" },
      { color: "bg-[#7cb5d9]", value: 360, label: "Contacted" },
      { color: "bg-accent-green", value: 240, label: "Qualified" },
      { color: "bg-accent-red", value: 60, label: "Disqualified" },
    ],
  },
];

const legendItems = [
  { color: "bg-[#d9d9d9]", label: "Uncontacted" },
  { color: "bg-[#7cb5d9]", label: "Contacted" },
  { color: "bg-accent-green", label: "Qualified" },
  { color: "bg-accent-red", label: "Disqualified" },
];

export default function PotentialMatchesScreening() {
  return (
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-8">
        <div className="flex items-start justify-between">
          <h2 className="text-[36px] tracking-[-0.72px] leading-none">
            Potential Matches Screening
          </h2>
          <div className="flex gap-3">
            {legendItems.map((item) => (
              <div key={item.label} className="flex gap-2 items-center">
                <div className={`${item.color} w-3 h-3 rounded-full`} />
                <span className="text-[12px] tracking-[-0.12px] text-text-secondary">
                  {item.label}
                </span>
              </div>
            ))}
          </div>
        </div>

        <div className="flex flex-col gap-6">
          {segments.map((segment) => (
            <div key={segment.label} className="flex flex-col gap-3">
              <div className="flex items-center justify-between">
                <span className="text-[16px] tracking-[-0.16px]">
                  {segment.label}
                </span>
                <span className="text-[14px] tracking-[-0.14px] text-text-secondary">
                  {segment.total.toLocaleString()} total
                </span>
              </div>
              <div className="flex h-[40px] rounded overflow-hidden w-full">
                {segment.bars.map((bar) => (
                  <div
                    key={bar.label}
                    className={`${bar.color} h-full`}
                    style={{ width: `${(bar.value / segment.total) * 100}%` }}
                  />
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
