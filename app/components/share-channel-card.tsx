interface StatCard {
  label: string;
  value: string;
  percentage: string;
  percentageColor: "green" | "red";
}

interface ShareChannelCardProps {
  title: string;
  channelLabel: string;
  buttonLabel: string;
  stats: StatCard[];
}

export default function ShareChannelCard({
  title,
  channelLabel,
  buttonLabel,
  stats,
}: ShareChannelCardProps) {
  return (
    <div className="bg-surface border border-border rounded-xl flex flex-col gap-12 p-12 w-full">
      <h2 className="text-[36px] tracking-[-0.72px] leading-none">
        {title}
      </h2>

      <div className="flex gap-3">
        {stats.map((stat) => (
          <div
            key={stat.label}
            className="flex-1 border border-border rounded-xl overflow-hidden flex flex-col items-center justify-between h-[164px]"
          >
            <span className="text-[16px] tracking-[-0.16px] pt-4">
              {stat.label}
            </span>
            <span className="text-[56px] tracking-[-1.12px] leading-none">
              {stat.value}
            </span>
            <div
              className={`w-full flex items-center justify-center p-2 ${
                stat.percentageColor === "green"
                  ? "bg-accent-green-bg"
                  : "bg-accent-red-bg"
              }`}
            >
              <span
                className={`text-[16px] tracking-[-0.16px] ${
                  stat.percentageColor === "green"
                    ? "text-accent-green"
                    : "text-accent-red"
                }`}
              >
                {stat.percentage}
              </span>
            </div>
          </div>
        ))}
      </div>

      <div className="flex flex-col gap-3">
        <p className="text-[24px]">{channelLabel}</p>
        <button className="bg-[#202020] border border-[rgba(0,0,0,0.25)] text-white rounded p-6 text-[20px] text-left cursor-pointer hover:bg-[#333] transition-colors">
          {buttonLabel}
        </button>
      </div>
    </div>
  );
}
