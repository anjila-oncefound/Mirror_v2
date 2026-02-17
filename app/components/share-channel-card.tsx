interface StatCard {
  label: string;
  value: string;
  percentage: string;
  barColor: string;
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
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-8">
        <div className="flex items-start justify-between">
          <h2 className="text-[36px] tracking-[-0.72px] leading-none">
            {title}
          </h2>
          <span className="text-[14px] tracking-[-0.14px] text-text-secondary">
            {channelLabel}
          </span>
        </div>

        <div className="flex gap-6">
          {stats.map((stat) => (
            <div
              key={stat.label}
              className="flex-1 border border-border rounded-xl overflow-hidden"
            >
              <div className="p-6 flex flex-col gap-3">
                <span className="text-[14px] tracking-[-0.14px] text-text-secondary">
                  {stat.label}
                </span>
                <div className="flex gap-2.5 items-end">
                  <span className="text-[36px] tracking-[-0.72px] leading-none">
                    {stat.value}
                  </span>
                  <span className="text-[16px] tracking-[-0.16px] text-text-secondary pb-1">
                    {stat.percentage}
                  </span>
                </div>
              </div>
              <div className={`${stat.barColor} h-[4px] w-full`} />
            </div>
          ))}

          {/* Action button */}
          <div className="flex-1 border border-border rounded-xl flex items-center justify-center">
            <button className="bg-[#202020] text-white rounded-lg px-6 py-3 text-[14px] tracking-[-0.14px] cursor-pointer hover:bg-[#333] transition-colors">
              {buttonLabel}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
