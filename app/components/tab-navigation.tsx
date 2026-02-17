"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const tabs = [
  { label: "Overview", href: "/study/overview", enabled: true },
  { label: "Definition", href: "/study/definition", enabled: true },
  { label: "Quotation", href: "/study/quotation", enabled: true },
  { label: "Recruitment", href: "/study/recruitment", enabled: true },
  { label: "Members", href: "#", enabled: false },
  { label: "Sessions", href: "#", enabled: false },
  { label: "Analyze", href: "#", enabled: false },
  { label: "Payments", href: "#", enabled: false },
  { label: "Settings", href: "/study/settings", enabled: true },
];

export default function TabNavigation() {
  const pathname = usePathname();

  return (
    <div className="bg-surface border-b border-border flex items-center h-[68px] w-full shadow-[0px_5px_5px_0px_rgba(0,0,0,0.02)]">
      {tabs.map((tab) => {
        const isActive = pathname === tab.href;

        if (!tab.enabled) {
          return (
            <span
              key={tab.label}
              className="flex-1 h-full flex items-center justify-center px-6 text-[20px] text-text-muted cursor-default"
            >
              {tab.label}
            </span>
          );
        }

        return (
          <Link
            key={tab.label}
            href={tab.href}
            className={`
              flex-1 h-full flex items-center justify-center px-6 text-[20px] transition-colors
              ${isActive
                ? "border-b-2 border-black text-black"
                : "text-black hover:bg-black/[0.02]"
              }
            `}
          >
            {tab.label}
          </Link>
        );
      })}
    </div>
  );
}
