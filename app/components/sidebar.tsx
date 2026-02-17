"use client";

import {
  LayoutDashboard,
  Users,
  MessageSquare,
  FolderOpen,
  Search,
  Settings,
} from "lucide-react";

const navItems = [
  { icon: LayoutDashboard, label: "Dashboard" },
  { icon: Users, label: "Members" },
  { icon: MessageSquare, label: "Messages" },
  { icon: FolderOpen, label: "Projects" },
  { icon: Search, label: "Search" },
];

export default function Sidebar() {
  return (
    <aside className="bg-surface border-r border-border flex flex-col items-center justify-between py-6 px-4 sticky top-0 h-screen shrink-0">
      <div className="flex flex-col items-center gap-16">
        {/* Logo */}
        <div className="w-9 h-11 flex items-center justify-center">
          <div className="w-8 h-8 rounded-lg bg-accent-orange flex items-center justify-center text-white font-bold text-sm">
            M
          </div>
        </div>

        {/* Navigation Icons */}
        <nav className="flex flex-col items-center gap-8">
          {navItems.map((item) => (
            <button
              key={item.label}
              className="w-6 h-6 text-black/60 hover:text-black transition-colors cursor-pointer"
              title={item.label}
            >
              <item.icon className="w-6 h-6" strokeWidth={1.5} />
            </button>
          ))}
        </nav>
      </div>

      {/* Bottom section */}
      <div className="flex flex-col items-center gap-8">
        <button className="w-6 h-6 text-black/60 hover:text-black transition-colors cursor-pointer" title="Settings">
          <Settings className="w-6 h-6" strokeWidth={1.5} />
        </button>
        <div className="w-12 h-12 rounded-full bg-gradient-to-br from-blue-400 to-purple-500 overflow-hidden" />
      </div>
    </aside>
  );
}
