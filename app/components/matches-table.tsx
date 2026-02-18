"use client";

import { useState } from "react";
import { Mail, ArrowUpRight } from "lucide-react";

type TagVariant = "qualified" | "standout" | "scheduled" | "disqualified" | "incomplete";

interface MatchRow {
  id: string;
  name: string;
  lastEngagement: string | null;
  tags: TagVariant[];
  screenedOn: string;
  sessionStatus: string | null;
}

const tagStyles: Record<TagVariant, string> = {
  qualified: "bg-accent-green-bg text-accent-green",
  standout: "bg-accent-green-bg text-accent-green",
  scheduled: "bg-[rgba(255,200,0,0.1)] text-[#968b29]",
  disqualified: "bg-accent-red-bg text-accent-red",
  incomplete: "bg-tag-gray-bg text-text-secondary",
};

const tagLabels: Record<TagVariant, string> = {
  qualified: "Qualified",
  standout: "Standout",
  scheduled: "Scheduled",
  disqualified: "Disqualified",
  incomplete: "Incomplete",
};

const matchesData: MatchRow[] = [
  { id: "1", name: "Alex Turner", lastEngagement: "1 Message", tags: ["scheduled", "qualified", "standout"], screenedOn: "Monday, 10:21 AM", sessionStatus: "Upcoming: Monday, 10:21 AM" },
  { id: "2", name: "Maya Johnson", lastEngagement: "1 Message", tags: ["qualified", "standout"], screenedOn: "Tuesday, 11:21 AM", sessionStatus: null },
  { id: "3", name: "Liam Brown", lastEngagement: "1 Message", tags: ["qualified", "standout"], screenedOn: "Tuesday, 11:21 AM", sessionStatus: null },
  { id: "4", name: "Emma Wilson", lastEngagement: "1 Message", tags: ["qualified"], screenedOn: "Tuesday, 11:21 AM", sessionStatus: null },
  { id: "5", name: "Noah Davis", lastEngagement: "1 Message", tags: ["qualified"], screenedOn: "Tuesday, 11:21 AM", sessionStatus: null },
  { id: "6", name: "Olivia Garcia", lastEngagement: null, tags: ["disqualified"], screenedOn: "Tuesday, 11:21 AM", sessionStatus: null },
  { id: "7", name: "Ethan Martinez", lastEngagement: null, tags: ["incomplete"], screenedOn: "Tuesday, 11:21 AM", sessionStatus: null },
  { id: "8", name: "Sophia Rodriguez", lastEngagement: null, tags: ["qualified"], screenedOn: "Tuesday, 11:21 AM", sessionStatus: null },
  { id: "9", name: "Aiden Lee", lastEngagement: null, tags: ["qualified"], screenedOn: "Tuesday, 11:21 AM", sessionStatus: null },
  { id: "10", name: "Isabella Hernandez", lastEngagement: null, tags: ["disqualified"], screenedOn: "Tuesday, 11:21 AM", sessionStatus: null },
  { id: "11", name: "Lucas Lopez", lastEngagement: null, tags: ["disqualified"], screenedOn: "Tuesday, 11:21 AM", sessionStatus: null },
];

function Tag({ variant }: { variant: TagVariant }) {
  return (
    <span className={`${tagStyles[variant]} px-3 py-1 rounded-xl text-[12px] tracking-[-0.12px]`}>
      {tagLabels[variant]}
    </span>
  );
}

function InsightBadge({ label, variant }: { label: string; variant: "blue" | "outline" }) {
  const styles = variant === "blue"
    ? "bg-accent-blue-bg text-accent-blue"
    : "bg-premium-bg text-[rgba(0,51,255,0.79)]";
  return (
    <span className={`${styles} px-3 py-1 rounded-xl text-[12px] tracking-[-0.12px]`}>
      {label}
    </span>
  );
}

export default function MatchesTable() {
  const [selected, setSelected] = useState<Set<string>>(new Set(["3", "6", "7"]));
  const [currentPage] = useState(1);

  const toggleRow = (id: string) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const toggleAll = () => {
    if (selected.size === matchesData.length) {
      setSelected(new Set());
    } else {
      setSelected(new Set(matchesData.map((r) => r.id)));
    }
  };

  return (
    <div className="flex flex-col">
      {/* Toolbar */}
      <div className="flex items-center justify-end px-16 py-8 gap-3">
        <button className="border border-border rounded-xl px-6 py-3 text-[20px] hover:bg-black/[0.02] transition-colors cursor-pointer">
          Sort by
        </button>
        <button className="border border-border rounded-xl px-6 py-3 text-[20px] hover:bg-black/[0.02] transition-colors cursor-pointer flex items-center gap-3">
          <span>Filter</span>
          <div className="flex items-center gap-1">
            <span className="bg-tag-gray-bg px-1.5 py-0.5 rounded text-[12px] tracking-[-0.12px] text-text-secondary">WHERE</span>
            <span className="text-[14px]">Tags</span>
            <span className="bg-tag-gray-bg px-1.5 py-0.5 rounded text-[12px] tracking-[-0.12px] text-text-secondary">IS</span>
            <span className="text-[14px]">Qualified</span>
          </div>
        </button>
        <button className="border border-border rounded-xl px-6 py-3 text-[20px] hover:bg-black/[0.02] transition-colors cursor-pointer">
          Export
        </button>
        <button className="border border-border rounded-xl px-6 py-3 text-[20px] hover:bg-black/[0.02] transition-colors cursor-pointer">
          Import
        </button>
        <button className="bg-[#202020] text-white rounded-xl px-6 py-3 text-[20px] cursor-pointer hover:bg-[#333] transition-colors">
          Schedule Sessions
        </button>
      </div>

      {/* Table */}
      <div className="px-16">
        {/* Header */}
        <div className="flex items-center py-4 border-b border-border">
          <div className="w-[61px] shrink-0 flex items-center justify-center">
            <button
              onClick={toggleAll}
              className={`w-[25px] h-[25px] rounded border cursor-pointer transition-colors ${
                selected.size === matchesData.length
                  ? "bg-accent-blue border-accent-blue"
                  : "border-border"
              }`}
            />
          </div>
          <span className="flex-1 text-[20px]">Member Name</span>
          <span className="flex-1 text-[20px]">Last Engagement</span>
          <span className="flex-1 text-[20px]">Recruitment Tags</span>
          <span className="flex-1 text-[20px]">Screened on</span>
          <span className="flex-1 text-[20px]">Session Status</span>
          <span className="flex-1 text-[20px]">Insights</span>
          <span className="flex-1 text-[20px]">Actions</span>
        </div>

        {/* Rows */}
        {matchesData.map((row) => {
          const isSelected = selected.has(row.id);
          return (
            <div
              key={row.id}
              className="flex items-center py-[18px] border-b border-border"
            >
              <div className="w-[61px] shrink-0 flex items-center justify-center">
                <button
                  onClick={() => toggleRow(row.id)}
                  className={`w-[25px] h-[25px] rounded border cursor-pointer transition-colors ${
                    isSelected
                      ? "bg-accent-blue border-accent-blue"
                      : "border-border"
                  }`}
                />
              </div>
              <span className="flex-1 text-[16px] tracking-[-0.16px]">{row.name}</span>
              <div className="flex-1">
                {row.lastEngagement ? (
                  <div className="flex items-center gap-2">
                    <Mail className="w-[14px] h-[11px] text-text-secondary" strokeWidth={1.5} />
                    <span className="text-[12px] tracking-[-0.12px]">{row.lastEngagement}</span>
                  </div>
                ) : (
                  <Mail className="w-[14px] h-[11px] text-text-secondary" strokeWidth={1.5} />
                )}
              </div>
              <div className="flex-1 flex gap-1 flex-wrap">
                {row.tags.map((tag) => (
                  <Tag key={tag} variant={tag} />
                ))}
              </div>
              <span className="flex-1 text-[16px] tracking-[-0.16px]">{row.screenedOn}</span>
              <span className="flex-1 text-[16px] tracking-[-0.16px]">
                {row.sessionStatus || ""}
              </span>
              <div className="flex-1 flex gap-2">
                <InsightBadge label="Summary" variant="blue" />
                <InsightBadge label="Key Moments" variant="outline" />
              </div>
              <div className="flex-1 flex gap-3">
                <button className="flex items-center gap-1 border border-border rounded-xl px-3 py-1.5 text-[14px] tracking-[-0.14px] cursor-pointer hover:bg-black/[0.02] transition-colors">
                  Send Email
                  <ArrowUpRight className="w-[6px] h-[6px]" strokeWidth={2} />
                </button>
                <button className="flex items-center gap-1 border border-border rounded-xl px-3 py-1.5 text-[14px] tracking-[-0.14px] cursor-pointer hover:bg-black/[0.02] transition-colors">
                  See Profile
                  <ArrowUpRight className="w-[6px] h-[6px]" strokeWidth={2} />
                </button>
              </div>
            </div>
          );
        })}
      </div>

      {/* Pagination */}
      <div className="flex items-center justify-end px-16 py-8 gap-3">
        {[1, 2, 3, 4].map((page) => (
          <button
            key={page}
            className={`w-16 h-16 flex items-center justify-center rounded-xl text-[22px] cursor-pointer transition-colors ${
              page === currentPage
                ? "border border-black text-black"
                : "border border-border text-text-secondary hover:border-black/20"
            }`}
          >
            {page}
          </button>
        ))}
        <span className="w-16 h-16 flex items-center justify-center border border-border rounded-xl text-[22px] text-text-secondary">
          ...
        </span>
      </div>
    </div>
  );
}
