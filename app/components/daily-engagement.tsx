const chartData = [
  { label: "March 2", attended: 1, scheduled: 132, submissions: 132 },
  { label: "March 3", attended: 31, scheduled: 44, submissions: 185 },
  { label: "March 4", attended: 1, scheduled: 35, submissions: 27 },
  { label: "March 5", attended: 15, scheduled: 47, submissions: 172 },
  { label: "March 6", attended: 87, scheduled: 34, submissions: 132 },
  { label: "March 7", attended: 54, scheduled: 68, submissions: 132 },
  { label: "March 8", attended: 6, scheduled: 25, submissions: 64 },
  { label: "March 9", attended: 206, scheduled: 36, submissions: 132 },
  { label: "March 10", attended: 31, scheduled: 44, submissions: 185 },
  { label: "March 11", attended: 1, scheduled: 35, submissions: 27 },
  { label: "March 12", attended: 15, scheduled: 47, submissions: 172 },
  { label: "March 13", attended: 1, scheduled: 34, submissions: 132 },
  { label: "March 14", attended: 54, scheduled: 68, submissions: 132 },
  { label: "March 15", attended: 6, scheduled: 25, submissions: 64 },
  { label: "March 16", attended: 132, scheduled: 132, submissions: 132 },
  { label: "March 17", attended: 31, scheduled: 44, submissions: 185 },
  { label: "March 18", attended: 1, scheduled: 35, submissions: 27 },
];

const yLabels = [140, 130, 120, 110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0];

const legend = [
  { color: "bg-[#b1d0e1]", label: "Submissions", value: "00%" },
  { color: "bg-[#7cb5d9]", label: "Scheduled", value: "00%" },
  { color: "bg-[#2f91cf]", label: "Attended", value: "00%" },
];

export default function DailyEngagement() {
  return (
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-8">
        {/* Header */}
        <div className="flex items-start justify-between w-full">
          <h2 className="text-[36px] tracking-[-0.72px] leading-none">Project Daily Engagement</h2>
          <div className="flex gap-2.5">
            <button className="bg-surface border border-border rounded p-3 text-[12px] tracking-[-0.12px] cursor-pointer hover:border-black/20 transition-colors">
              Start Date
            </button>
            <button className="bg-surface border border-border rounded p-3 text-[12px] tracking-[-0.12px] cursor-pointer hover:border-black/20 transition-colors">
              End Date
            </button>
          </div>
        </div>

        {/* Chart area */}
        <div className="flex gap-6 w-full">
          {/* Y-axis labels */}
          <div className="flex flex-col items-start justify-between pb-[43px] text-[12px] tracking-[-0.12px] shrink-0">
            {yLabels.map((label) => (
              <p key={label}>{label}</p>
            ))}
          </div>

          {/* Bars */}
          <div className="flex-1 flex gap-3 items-end">
            {chartData.map((bar) => (
              <div key={bar.label} className="flex-1 flex flex-col gap-8 items-center">
                <div className="flex flex-col items-start justify-center overflow-clip rounded w-full">
                  <div className="bg-[#2f91cf] w-full" style={{ height: `${bar.attended}px` }} />
                  <div className="bg-[#7cb5d9] w-full" style={{ height: `${bar.scheduled}px` }} />
                  <div className="bg-[#b1d0e1] w-full" style={{ height: `${bar.submissions}px` }} />
                </div>
                <p className="text-[12px] tracking-[-0.12px] whitespace-nowrap">{bar.label}</p>
              </div>
            ))}
          </div>

          {/* Legend */}
          <div className="flex flex-col gap-2 shrink-0 w-[176px]">
            {legend.map((item) => (
              <div key={item.label} className="flex items-center justify-between w-full">
                <div className="flex gap-3 items-center">
                  <div className={`${item.color} w-4 h-4 rounded-full`} />
                  <p className="text-[12px] tracking-[-0.12px]">{item.label}</p>
                </div>
                <p className="text-[12px] tracking-[-0.12px]">{item.value}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
