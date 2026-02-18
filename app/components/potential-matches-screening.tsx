const segments = [
  {
    label: "Segment 1: Singapore",
    bars: [
      { color: "bg-[rgba(0,0,0,0.05)]", flex: true },
      { color: "bg-[#c5f1d8]", width: 279 },
      { color: "bg-accent-green", width: 500 },
      { color: "bg-accent-red", width: 225 },
    ],
  },
  {
    label: "Segment 2: Kuala Lampur",
    bars: [
      { color: "bg-[rgba(0,0,0,0.05)]", flex: true },
      { color: "bg-[#c5f1d8]", width: 79 },
      { color: "bg-accent-green", width: 341 },
      { color: "bg-accent-red", width: 669 },
    ],
  },
];

const legendItems = [
  { color: "bg-[#f2f2f2]", label: "Outreach", percentage: "00%" },
  { color: "bg-[#c5f1d8]", label: "Required", percentage: "00%" },
  { color: "bg-accent-green", label: "Qualified", percentage: "00%" },
  { color: "bg-accent-red", label: "Disqualified", percentage: "00%" },
];

export default function PotentialMatchesScreening() {
  return (
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-8">
        <div className="flex items-start justify-between">
          <h2 className="text-[36px] tracking-[-0.72px] leading-none">
            Potential Matches Screening
          </h2>
          <div className="flex flex-col gap-2 w-[176px]">
            {legendItems.map((item) => (
              <div key={item.label} className="flex items-center justify-between">
                <div className="flex gap-3 items-center">
                  <div className={`${item.color} w-4 h-4 rounded-full`} />
                  <span className="text-[12px] tracking-[-0.12px]">
                    {item.label}
                  </span>
                </div>
                <span className="text-[12px] tracking-[-0.12px]">
                  {item.percentage}
                </span>
              </div>
            ))}
          </div>
        </div>

        <div className="flex flex-col gap-6">
          {segments.map((segment) => (
            <div key={segment.label} className="flex flex-col gap-3">
              <span className="text-[20px] leading-none">
                {segment.label}
              </span>
              <div className="flex h-16 rounded overflow-hidden w-full">
                {segment.bars.map((bar, i) =>
                  bar.flex ? (
                    <div key={i} className={`${bar.color} h-full flex-1`} />
                  ) : (
                    <div
                      key={i}
                      className={`${bar.color} h-full shrink-0`}
                      style={{ width: bar.width }}
                    />
                  )
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
