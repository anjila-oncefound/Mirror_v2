import { ChevronDown } from "lucide-react";

function Badge({ children, variant = "default" }: { children: React.ReactNode; variant?: "default" | "orange" | "gray" }) {
  const bgMap = {
    default: "bg-white/10",
    orange: "bg-tag-orange-bg",
    gray: "bg-tag-gray-bg",
  };

  return (
    <span className={`${bgMap[variant]} px-3 py-1 rounded-xl text-[12px] tracking-[-0.12px]`}>
      {children}
    </span>
  );
}

interface StudyHeaderProps {
  statusLabel?: string;
  dropdownLabel?: string | null;
  urlDisplay?: string | null;
}

export default function StudyHeader({ statusLabel = "Draft", dropdownLabel = "Segments: Singapore", urlDisplay = null }: StudyHeaderProps) {
  return (
    <div className="flex gap-6 items-start justify-center p-16 w-full">
      {/* Left: Title + metadata */}
      <div className="flex-1 flex flex-col gap-6">
        {/* Study ID */}
        <div className="inline-flex">
          <div className="border border-border rounded-full">
            <Badge>SGRN-01X</Badge>
          </div>
        </div>

        {/* Title */}
        <h1 className="text-[56px] text-black tracking-[-1.12px] leading-none">
          SGB Loan Program
        </h1>

        {/* Metadata */}
        <div className="flex gap-6 items-center">
          <div className="flex gap-3 items-center">
            <span className="text-[16px] tracking-[-0.16px]">Stage</span>
            <Badge variant="orange">Quotation</Badge>
          </div>
          <div className="flex gap-3 items-center">
            <span className="text-[16px] tracking-[-0.16px]">Status</span>
            <Badge variant="gray">{statusLabel}</Badge>
          </div>
          <div className="flex gap-3 items-center">
            <span className="text-[16px] tracking-[-0.16px]">Recruiter</span>
            <div className="w-6 h-6 rounded-full bg-gradient-to-br from-emerald-400 to-teal-500" />
          </div>
        </div>
      </div>

      {/* Right: Dropdown */}
      {dropdownLabel && (
        <div className="w-[318px] shrink-0">
          <button className="bg-surface border border-border rounded-xl flex items-center justify-between p-6 w-full hover:border-black/20 transition-colors cursor-pointer">
            <span className="text-[20px] text-black">{dropdownLabel}</span>
            <ChevronDown className="w-[18px] h-[10px] text-black/60" strokeWidth={1.5} />
          </button>
        </div>
      )}

      {/* Right: URL display */}
      {urlDisplay && (
        <div className="shrink-0">
          <div className="bg-surface border border-border rounded-xl flex items-center p-6">
            <span className="text-[16px] text-text-secondary tracking-[-0.16px]">{urlDisplay}</span>
          </div>
        </div>
      )}
    </div>
  );
}
