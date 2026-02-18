"use client";

import { ArrowUpRight } from "lucide-react";

interface Session {
  name: string;
  time: string;
  action: "mark-attendance" | "join-meeting";
}

interface DayColumn {
  label: string;
  sessions: Session[];
}

const weekData: DayColumn[] = [
  {
    label: "12th, Monday",
    sessions: [
      { name: "James Meldrum", time: "In 2 min", action: "mark-attendance" },
    ],
  },
  { label: "13th, Tuesday", sessions: [] },
  {
    label: "14th, Wednesday",
    sessions: [
      { name: "James Meldrum", time: "10:20am", action: "join-meeting" },
      { name: "James Meldrum", time: "2pm", action: "join-meeting" },
    ],
  },
  { label: "15th, Thursday", sessions: [] },
  {
    label: "16th, Friday",
    sessions: [
      { name: "James Meldrum", time: "In 2 min", action: "join-meeting" },
    ],
  },
  { label: "18th, Saturday", sessions: [] },
  { label: "19th, Sunday", sessions: [] },
];

function MeetIcon() {
  return (
    <svg width="22" height="18" viewBox="0 0 22 18" fill="none" xmlns="http://www.w3.org/2000/svg">
      <rect x="0" y="0" width="13" height="18" rx="2" fill="#00832D" />
      <rect x="4" y="0" width="9" height="18" fill="#00AC47" />
      <path d="M13 5L22 0V18L13 13V5Z" fill="#00832D" />
      <path d="M13 5L18 2V8L13 5Z" fill="#2684FC" />
      <path d="M13 13L18 16V10L13 13Z" fill="#FFBA00" />
      <rect x="4" y="5" width="9" height="8" fill="#00AC47" opacity="0.3" />
    </svg>
  );
}

function SessionCard({ session }: { session: Session }) {
  return (
    <div className="bg-surface border border-border rounded-xl p-4 flex flex-col gap-3">
      <div className="flex items-center justify-between">
        <MeetIcon />
        <span className="text-[12px] tracking-[-0.12px] text-text-secondary">
          {session.time}
        </span>
      </div>
      <span className="text-[16px] tracking-[-0.16px]">{session.name}</span>
      {session.action === "mark-attendance" ? (
        <button className="bg-accent-green text-white rounded-lg px-4 py-3 text-[14px] tracking-[-0.14px] cursor-pointer hover:bg-[#14994f] transition-colors">
          Mark Attendence
        </button>
      ) : (
        <button className="border border-border rounded-lg px-4 py-3 text-[14px] tracking-[-0.14px] flex items-center justify-center gap-1 cursor-pointer hover:bg-black/[0.02] transition-colors">
          Join Meeting
          <ArrowUpRight className="w-[6px] h-[6px]" strokeWidth={2} />
        </button>
      )}
    </div>
  );
}

export default function SessionsCalendar() {
  return (
    <div className="flex flex-col">
      {/* Toolbar */}
      <div className="flex items-center justify-end px-16 py-8 gap-3">
        <button className="border border-border rounded-xl px-6 py-3 text-[20px] hover:bg-black/[0.02] transition-colors cursor-pointer">
          Pick Dates
        </button>
        <button className="border border-border rounded-xl px-6 py-3 text-[20px] hover:bg-black/[0.02] transition-colors cursor-pointer">
          Select Calender
        </button>
        <button className="bg-[#202020] text-white rounded-xl px-6 py-3 text-[20px] cursor-pointer hover:bg-[#333] transition-colors">
          New Session
        </button>
      </div>

      {/* Day headers */}
      <div className="flex px-[10px]">
        {weekData.map((day) => (
          <div
            key={day.label}
            className="flex-1 flex items-center justify-center py-2.5"
          >
            <span className="text-[20px]">{day.label}</span>
          </div>
        ))}
      </div>

      {/* Calendar grid */}
      <div className="flex px-[10px] min-h-[648px]">
        {weekData.map((day) => (
          <div
            key={day.label}
            className="flex-1 border-l border-border first:border-l-0 p-2.5 flex flex-col gap-2.5"
          >
            {day.sessions.map((session, i) => (
              <SessionCard key={i} session={session} />
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}
