export default function TotalProjectCost() {
  return (
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-8">
        <h2 className="text-[36px] tracking-[-0.72px] leading-none">Total Project Cost</h2>

        {/* Per-member breakdown */}
        <div className="flex gap-6 w-full">
          <div className="flex-1 flex flex-col gap-6 text-[20px]">
            <p>Number of Member:</p>
            <p>Base Cost per Member:</p>
            <p>Premium per Member:</p>
            <p>Total Fee per Member:</p>
          </div>
          <div className="flex flex-col gap-6 items-end text-[20px]">
            <p>16</p>
            <p>$200 SGD</p>
            <p>$45 SGD</p>
            <p>$245 SGD</p>
          </div>
        </div>

        {/* Divider */}
        <div className="border-t border-border" />

        {/* Total breakdown */}
        <div className="flex gap-6 w-full">
          <div className="flex-1 flex flex-col gap-6 text-[24px] leading-none">
            <p>Total Scheduling Fee:</p>
            <p>Screening Fee:</p>
            <p>Additional Recruitment Fee:</p>
            <p>Research Fees:</p>
            <p className="font-bold">Total Project Cost:</p>
          </div>
          <div className="flex flex-col gap-6 items-end text-[24px] leading-none">
            <p>$3,920 SGD</p>
            <p>$1,300 SGD</p>
            <p>$0 SGD</p>
            <p>$0 SGD</p>
            <p className="font-bold">$5,220 SGD</p>
          </div>
        </div>
      </div>
    </div>
  );
}
