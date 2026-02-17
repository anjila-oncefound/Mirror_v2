"use client";

import { Info, Pencil, ChevronDown } from "lucide-react";
import { useState, useRef, useEffect } from "react";

/* ── Stat Cards ── */

function StatCard({ label, value }: { label: string; value: string }) {
  return (
    <div className="border border-border rounded-xl flex flex-col gap-3 items-center justify-center flex-1 py-6 overflow-clip">
      <p className="text-[16px] tracking-[-0.16px]">{label}</p>
      <p className="text-[56px] tracking-[-1.12px] leading-none">{value}</p>
    </div>
  );
}

/* ── Premiums Table ── */

const premiumRows = [
  { filter: "Location", value: "Singapore", size: "24,000", premium: "Premium $0.01" },
  { filter: "Gender", value: "Female", size: "12,500", premium: "Premium $5" },
  { filter: "Income", value: "20k/month", size: "8,900", premium: "Premium $5" },
  { filter: "Belief: Sustainability", value: "Think carbon negative options are scams", size: "8,900", premium: "Premium $5" },
  { filter: "Belief: Family values", value: "Looking for self reliance", size: "250", premium: "Premium: 25$" },
  { filter: "Belief: Money", value: "Cars are a luxury", size: "Study Specific Question", premium: null },
];

/* ── Input Field ── */

function InputField({ label, value, isDropdown }: { label: string; value: string; isDropdown?: boolean }) {
  return (
    <div className="flex flex-1 flex-col gap-3 items-start">
      <p className="text-[16px] tracking-[-0.16px] w-full">{label}</p>
      <div className={`border border-border rounded-xl flex items-center ${isDropdown ? "justify-between" : "items-start"} p-6 w-full`}>
        <p className={`text-[20px] ${isDropdown ? "text-black" : "text-black/50"}`}>{value}</p>
        {isDropdown && (
          <ChevronDown className="w-[18px] h-[10px] text-black/60" strokeWidth={1.5} />
        )}
      </div>
    </div>
  );
}

/* ── Info Tooltip ── */

function InfoTooltip({ children, onClose }: { children: React.ReactNode; onClose: () => void }) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClick(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        onClose();
      }
    }
    document.addEventListener("mousedown", handleClick);
    return () => document.removeEventListener("mousedown", handleClick);
  }, [onClose]);

  return (
    <div ref={ref} className="absolute right-0 top-full mt-2 z-50">
      {children}
    </div>
  );
}

/* ── Screening Costs Tooltip ── */

function ScreeningTooltip() {
  return (
    <div className="bg-[#202020] rounded p-4 w-[307px] shadow-[0px_4px_4px_0px_rgba(0,0,0,0.25)]">
      <div className="flex flex-col gap-4 items-center">
        <p className="text-[14px] text-white tracking-[-0.14px] w-full">
          Required Participants to Screen
        </p>
        <p className="text-[12px] text-white/50 tracking-[-0.12px] w-full">
          We calculate the number of people you must screen to reach your target completes, based on our estimated qualification and show rates.
        </p>
        <p className="text-[12px] text-white leading-[1.2] w-full">
          Additional Participants Needed ÷ Qualification Rate ÷ Show Rate
        </p>

        {/* Divider */}
        <div className="border-t border-white/20 w-full" />

        {/* Breakdown */}
        <div className="flex flex-col gap-2.5 w-full text-[12px] text-white/50 tracking-[-0.12px]">
          <div className="flex gap-2 items-start w-full">
            <p className="flex-1">Target Participants to Qualified</p>
            <p className="shrink-0">3/16</p>
          </div>
          <div className="flex gap-2 items-start w-full">
            <p className="flex-1">Additional Participants Needed</p>
            <p className="shrink-0">13</p>
          </div>
          <div className="flex gap-2 items-start w-full">
            <p className="flex-1">Estimated Qualification Rate</p>
            <p className="shrink-0">50%</p>
          </div>
          <div className="flex gap-2 items-start w-full">
            <p className="flex-1">Estimated Show Rate</p>
            <p className="shrink-0">50%</p>
          </div>
        </div>

        {/* Formula result */}
        <div className="bg-white/10 border border-white/10 rounded p-3 w-full">
          <p className="text-[12px] text-white leading-[1.2]">
            13 ÷ 50% ÷ 50% = 52 Screenings Required
          </p>
        </div>
      </div>
    </div>
  );
}

/* ── Recruitment Tooltip ── */

function RecruitmentTooltip() {
  return (
    <div className="bg-[#202020] rounded p-4 shadow-[0px_4px_4px_0px_rgba(0,0,0,0.25)]">
      <p className="text-[12px] text-white leading-[1.2] w-[244px]">
        If qualification falls below expected, additional recruitment beyond the current database may be required and will be quoted separately.
      </p>
    </div>
  );
}

/* ── Section Header with Tooltip ── */

function SectionHeader({ title, tooltip }: { title: string; tooltip?: "screening" | "recruitment" }) {
  const [open, setOpen] = useState(false);

  return (
    <div className="flex items-center justify-between w-full relative">
      <h2 className="text-[36px] tracking-[-0.72px] leading-none">{title}</h2>
      {tooltip && (
        <>
          <button
            onClick={() => setOpen(!open)}
            className="cursor-pointer"
          >
            <Info className="w-[18px] h-[18px] text-black" strokeWidth={1.5} />
          </button>
          {open && (
            <InfoTooltip onClose={() => setOpen(false)}>
              {tooltip === "screening" ? <ScreeningTooltip /> : <RecruitmentTooltip />}
            </InfoTooltip>
          )}
        </>
      )}
    </div>
  );
}

/* ── Main Component ── */

export default function ProjectDetailsCard() {
  return (
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-16">
        {/* Project Details */}
        <div className="flex flex-col gap-8">
          <h2 className="text-[36px] tracking-[-0.72px] leading-none">Project Details</h2>
          <div className="flex gap-3 w-full">
            <StatCard label="Qualified Matches" value="3/16" />
            <StatCard label="Incentive per Match" value="$100" />
            <StatCard label="Base Session Cost per Match" value="$100" />
            <StatCard label="Currency" value="SGD" />
          </div>
        </div>

        {/* Premiums per Match */}
        <div className="flex flex-col gap-8">
          <h2 className="text-[36px] tracking-[-0.72px] leading-none">Premiums per Match</h2>
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
              {premiumRows.map((row, i) => (
                <div
                  key={row.filter}
                  className={`flex items-center px-6 py-[18px] ${i < premiumRows.length - 1 ? "border-b border-border" : ""} ${i % 2 === 1 ? "bg-black/[0.01]" : ""}`}
                >
                  <p className="flex-1 text-[16px] tracking-[-0.16px]">{row.filter}</p>
                  <p className="flex-1 text-[16px] tracking-[-0.16px]">{row.value}</p>
                  <p className="flex-1 text-[16px] tracking-[-0.16px]">{row.size}</p>
                  <div className="flex-1">
                    {row.premium ? (
                      <span className="bg-premium-bg px-3 py-1 rounded-xl text-[12px] tracking-[-0.12px]">
                        {row.premium}
                      </span>
                    ) : (
                      <span className="opacity-0 bg-premium-bg px-3 py-1 rounded-xl text-[12px]">
                        Premium $5
                      </span>
                    )}
                  </div>
                  <button className="w-6 h-6 flex items-center justify-center text-black hover:text-black cursor-pointer">
                    <Pencil className="w-4 h-4" strokeWidth={1.5} />
                  </button>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Screening Costs */}
        <div className="flex flex-col gap-8">
          <SectionHeader title="Screening Costs" tooltip="screening" />
          <div className="flex gap-6 items-end w-full">
            <InputField label="Screening cost per participant" value="$25" />
            <InputField label="*Qualification Rate" value="50%" />
            <InputField label="*Scheduling Rate" value="50%" />
            <InputField label="Required Participants to Screen" value="52" />
          </div>
        </div>

        {/* Additional Recruitment Costs */}
        <div className="flex flex-col gap-8">
          <SectionHeader title="Additional Recruitment Costs" tooltip="recruitment" />
          <div className="flex gap-6 items-start w-full">
            <InputField label="Participants to recruit" value="0" />
            <InputField label="Recruitment type" value="Offline" isDropdown />
            <InputField label="Recruitment Cost Per Participant" value="$50" />
          </div>
        </div>

        {/* Research Costs */}
        <div className="flex flex-col gap-8">
          <SectionHeader title="Research Costs" tooltip="recruitment" />
          <div className="flex gap-6 items-start w-full">
            <InputField label="Cost Type" value="Project Management" isDropdown />
            <InputField label="Cost" value="$0" />
          </div>
        </div>
      </div>
    </div>
  );
}
