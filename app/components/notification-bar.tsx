"use client";

import { X } from "lucide-react";
import { useState } from "react";

export default function NotificationBar() {
  const [visible, setVisible] = useState(true);

  if (!visible) return null;

  return (
    <div className="bg-accent-orange flex items-center justify-between px-8 py-[18px] w-full shrink-0">
      <p className="text-[16px] text-black tracking-[-0.16px]">
        The Credit Program Study with Singapore Bank has been successfully collected
      </p>
      <button
        onClick={() => setVisible(false)}
        className="w-6 h-6 flex items-center justify-center cursor-pointer hover:opacity-70 transition-opacity"
      >
        <X className="w-5 h-5" strokeWidth={1.5} />
      </button>
    </div>
  );
}
