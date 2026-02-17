import { Check } from "lucide-react";

function TimelineConnector() {
  return (
    <div className="w-5 flex justify-center">
      <div className="w-px h-[25px] bg-border" />
    </div>
  );
}

function ActivityItem({ icon, children }: { icon: "check" | "dot" | "avatar"; children: React.ReactNode }) {
  return (
    <div className="flex gap-2 items-center">
      {icon === "check" ? (
        <div className="w-5 h-5 rounded-full bg-accent-green flex items-center justify-center shrink-0">
          <Check className="w-3 h-3 text-white" strokeWidth={2.5} />
        </div>
      ) : icon === "avatar" ? (
        <div className="w-5 h-5 rounded-full bg-[#bfbfbf] flex items-center justify-center shrink-0 overflow-hidden">
          <div className="w-2.5 h-2.5 rounded-full bg-gray-400" />
        </div>
      ) : (
        <div className="w-5 h-5 rounded-full border-2 border-border bg-white shrink-0" />
      )}
      <div className="flex gap-2 items-center">
        <span className="font-bold text-[16px] tracking-[-0.16px]">You</span>
        {children}
      </div>
    </div>
  );
}

export default function RecentActivity() {
  return (
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-8">
        <h2 className="text-[36px] tracking-[-0.72px] leading-none">Recent Activity</h2>

        <div className="flex flex-col">
          {/* Item 1 - Accepted (green check) */}
          <ActivityItem icon="check">
            <span className="font-light text-[14px] tracking-[-0.14px] leading-[1.2]">Accepted 4 Matches</span>
          </ActivityItem>
          <TimelineConnector />

          {/* Item 2 - Accepted (gray dot) */}
          <ActivityItem icon="dot">
            <span className="font-light text-[14px] tracking-[-0.14px] leading-[1.2]">Accepted 4 Matches</span>
          </ActivityItem>
          <TimelineConnector />

          {/* Item 3 - Sent a reminder email with embedded card */}
          <div className="flex gap-2 items-start w-full">
            <div className="flex flex-col items-center shrink-0">
              <div className="w-5 h-5 rounded-full border-2 border-border bg-white shrink-0" />
              <div className="w-px flex-1 bg-border" />
            </div>
            <div className="flex-1 flex flex-col gap-2">
              <div className="flex gap-2 items-center">
                <span className="font-bold text-[16px] tracking-[-0.16px]">You</span>
                <span className="font-light text-[14px] tracking-[-0.14px] leading-[1.2]">Sent a reminder email</span>
              </div>
              {/* Email Card */}
              <div className="bg-surface border border-border rounded-xl p-[18px] shadow-[0px_4px_4px_0px_rgba(0,0,0,0.1)] w-full">
                <div className="flex flex-col gap-3">
                  <div className="flex gap-2 items-center">
                    <div className="w-[30px] h-[30px] rounded-full bg-gradient-to-br from-orange-300 to-red-400 shrink-0" />
                    <p className="text-[16px] tracking-[-0.16px]">Reminder: Panel Discussion Tomorrow</p>
                  </div>
                  <div className="text-[16px] tracking-[-0.16px] leading-[1.5]">
                    <p>Hi there,</p>
                    <p>Just a quick reminder about the panel discussion scheduled for tomorrow. We&apos;re excited to see you...</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <TimelineConnector />

          {/* Item 4 - Accepted (avatar) */}
          <ActivityItem icon="avatar">
            <span className="font-light text-[14px] tracking-[-0.14px] leading-[1.2]">Accepted 4 Matches</span>
          </ActivityItem>
        </div>
      </div>
    </div>
  );
}
