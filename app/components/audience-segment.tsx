import { Pencil, Lightbulb } from "lucide-react";

interface StatCardProps {
  label: string;
  value: string;
  change?: { value: string; positive: boolean };
}

function StatCard({ label, value, change }: StatCardProps) {
  return (
    <div className="border border-border rounded-xl flex flex-col items-center justify-between h-[128px] w-[240px] overflow-hidden pt-4">
      <p className="text-[16px] tracking-[-0.16px]">{label}</p>
      <p className="text-[56px] tracking-[-1.12px] leading-none">{value}</p>
      {change ? (
        <div className={`${change.positive ? "bg-accent-green-bg" : "bg-accent-red-bg"} flex items-center justify-center p-0.5 w-full`}>
          <p className={`text-[16px] tracking-[-0.16px] ${change.positive ? "text-accent-green" : "text-accent-red"}`}>
            {change.value}
          </p>
        </div>
      ) : (
        <div className="bg-accent-red-bg opacity-0 p-2 w-full">
          <p className="text-[16px]">&nbsp;</p>
        </div>
      )}
    </div>
  );
}

const filterRows = [
  { filter: "Location", value: "Singapore", size: "24,000", premium: "Premium $5" },
  { filter: "Gender", value: "Female", size: "12,500", premium: "Premium $5" },
  { filter: "Income", value: "4k-8k/month", size: "8,900", premium: "Premium $5" },
  { filter: "Belief: Sustainability", value: "Think carbon negative options are scams", size: "8,900", premium: "Premium $5" },
  { filter: "Belief: Family values", value: "Dependent on husband", size: "24", premium: "Premium: 25$" },
];

const additionalRows = [
  { filter: "Financial Products Used", value: "Frequency", size: "Study Specific Question" },
];

export default function AudienceSegment() {
  return (
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-8">
        {/* Title */}
        <h2 className="text-[36px] tracking-[-0.72px] leading-none">Audience Segment</h2>

        {/* Stat Cards */}
        <div className="flex gap-3">
          <StatCard label="Target Matches" value="16" />
          <StatCard label="Qualified Matches" value="4" change={{ value: "18.75%", positive: false }} />
          <StatCard label="Potentials Matches" value="240" change={{ value: "1,500%", positive: true }} />
        </div>

        {/* Filter Table */}
        <div className="flex flex-col gap-3">
          {/* Table Header */}
          <div className="flex items-center px-6">
            <p className="flex-1 text-[16px] tracking-[-0.16px]">Filter</p>
            <p className="flex-1 text-[16px] tracking-[-0.16px]">Value</p>
            <p className="flex-1 text-[16px] tracking-[-0.16px]">Size</p>
            <p className="flex-1 text-[16px] tracking-[-0.16px]">Premium</p>
            <div className="w-6 h-6" />
          </div>

          {/* Table Body */}
          <div className="bg-surface border border-border rounded">
            {filterRows.map((row, i) => (
              <div
                key={row.filter}
                className={`flex items-center px-6 py-[18px] border-b border-border ${i % 2 === 1 ? "bg-black/[0.01]" : ""}`}
              >
                <p className="flex-1 text-[16px] tracking-[-0.16px]">{row.filter}</p>
                <p className="flex-1 text-[16px] tracking-[-0.16px]">{row.value}</p>
                <p className="flex-1 text-[16px] tracking-[-0.16px]">{row.size}</p>
                <div className="flex-1">
                  <span className="bg-premium-bg px-3 py-1 rounded-xl text-[12px] tracking-[-0.12px]">
                    {row.premium}
                  </span>
                </div>
                <button className="w-6 h-6 flex items-center justify-center text-black/40 hover:text-black cursor-pointer">
                  <Pencil className="w-4 h-4" strokeWidth={1.5} />
                </button>
              </div>
            ))}

            {/* Yellow hint row */}
            <div className="bg-accent-yellow border border-border flex gap-2.5 items-center justify-center px-6 py-4">
              <Lightbulb className="w-4 h-4 text-accent-yellow-text" strokeWidth={1.5} />
              <p className="text-[16px] tracking-[-0.16px] text-accent-yellow-text">
                <span>Looking for more potential matches? </span>
                <span className="underline cursor-pointer">Find proximated data points</span>
              </p>
            </div>

            {/* Additional rows */}
            {additionalRows.map((row, i) => (
              <div
                key={row.filter}
                className={`flex items-center px-6 py-[18px] ${i % 2 === 1 ? "" : "bg-black/[0.01]"}`}
              >
                <p className="flex-1 text-[16px] tracking-[-0.16px]">{row.filter}</p>
                <p className="flex-1 text-[16px] tracking-[-0.16px]">{row.value}</p>
                <p className="flex-1 text-[16px] tracking-[-0.16px]">{row.size}</p>
                <div className="flex-1">
                  <span className="opacity-0 bg-premium-bg px-3 py-1 rounded-xl text-[12px]">
                    Premium $5
                  </span>
                </div>
                <button className="w-6 h-6 flex items-center justify-center text-black/40 hover:text-black cursor-pointer">
                  <Pencil className="w-4 h-4" strokeWidth={1.5} />
                </button>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
