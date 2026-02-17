const pipelineStages = [
  { title: "Segmented", value: "2040", change: "2,050%", positive: true, barHeight: 167 },
  { title: "Sent for Recruitment", value: "65", change: "2,050%", positive: true, barHeight: 100 },
  { title: "Submission", value: "25", change: "2,050%", positive: true, barHeight: 48 },
  { title: "Scheduled", value: "8", change: "10%", positive: false, barHeight: 8 },
  { title: "Attended", value: "0", change: "0%", positive: false, barHeight: 2 },
];

const description = "The Credit Program Study with Singapore Bank has been successfully collected";

export default function RecruitmentPipeline() {
  return (
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-8">
        <h2 className="text-[36px] tracking-[-0.72px] leading-none">Project Recruitment Pipeline</h2>

        <div className="border border-border rounded">
          {/* Stats row */}
          <div className="flex rounded-t-xl border-b border-border overflow-hidden">
            {pipelineStages.map((stage, i) => (
              <div
                key={stage.title}
                className={`flex-1 flex flex-col gap-[18px] px-6 py-[18px] ${i < pipelineStages.length - 1 ? "border-r border-border" : ""} ${i % 2 === 1 ? "bg-black/[0.01]" : ""}`}
              >
                <p className="text-[16px] tracking-[-0.16px]">{stage.title}</p>
                <p className="text-[14px] text-text-secondary tracking-[-0.14px] font-light leading-[1.2]">
                  {description}
                </p>
                <div className="flex gap-2.5 items-end">
                  <span className="text-[36px] tracking-[-0.72px] leading-none">{stage.value}</span>
                  <span className={`${stage.positive ? "bg-accent-green-bg text-accent-green" : "bg-accent-red-bg text-accent-red"} px-2 py-0.5 rounded-full text-[16px] tracking-[-0.16px]`}>
                    {stage.change}
                  </span>
                </div>
              </div>
            ))}
          </div>

          {/* Funnel area chart */}
          <div className="relative h-[231px]">
            {/* Column dividers */}
            <div className="absolute inset-0 flex pointer-events-none z-10">
              {pipelineStages.map((stage, i) => (
                <div
                  key={stage.title}
                  className={`flex-1 ${i > 0 ? "border-l border-border" : ""}`}
                />
              ))}
            </div>
            {/* Symmetrical funnel shape with color gradient */}
            <svg
              viewBox="0 0 1000 231"
              preserveAspectRatio="none"
              className="absolute inset-0 w-full h-full"
            >
              <defs>
                {/* Horizontal gradient: light on left → dark on right */}
                <linearGradient id="funnelGradient" x1="0" y1="0" x2="1" y2="0">
                  <stop offset="0%" stopColor="#b1d0e1" stopOpacity="0.35" />
                  <stop offset="30%" stopColor="#b1d0e1" stopOpacity="0.5" />
                  <stop offset="50%" stopColor="#7cb5d9" stopOpacity="0.65" />
                  <stop offset="75%" stopColor="#2f91cf" stopOpacity="0.8" />
                  <stop offset="100%" stopColor="#2f91cf" stopOpacity="1" />
                </linearGradient>
              </defs>
              {/* Funnel fill — top edge curves down, bottom edge curves up, converging right */}
              <path
                d="M0,32 C100,40 150,58 200,65 C300,80 350,86 400,91 C500,100 550,108 600,111 C700,113 800,114 1000,115
                   L1000,116
                   C800,117 700,118 600,120 C550,123 500,131 400,140 C350,145 300,152 200,166 C150,173 100,191 0,199 Z"
                fill="url(#funnelGradient)"
              />
              {/* Top edge stroke */}
              <path
                d="M0,32 C100,40 150,58 200,65 C300,80 350,86 400,91 C500,100 550,108 600,111 C700,113 800,114 1000,115"
                fill="none"
                stroke="#2f91cf"
                strokeWidth="2"
              />
              {/* Bottom edge stroke */}
              <path
                d="M0,199 C100,191 150,173 200,166 C300,152 350,145 400,140 C500,131 550,123 600,120 C700,118 800,117 1000,116"
                fill="none"
                stroke="#2f91cf"
                strokeWidth="2"
              />
            </svg>
          </div>
        </div>
      </div>
    </div>
  );
}
