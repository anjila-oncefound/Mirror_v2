export default function FinalizeQuote() {
  return (
    <div className="bg-surface border border-border rounded-xl p-8 w-full">
      <div className="flex flex-col gap-8">
        <h2 className="text-[36px] tracking-[-0.72px] leading-none">Finalize Quote</h2>

        {/* Fields */}
        <div className="flex flex-col gap-6">
          <div className="flex flex-col gap-3">
            <p className="text-[20px]">Taxes</p>
            <div className="border border-border rounded p-6">
              <p className="text-[20px] text-black/50">15%</p>
            </div>
          </div>

          <div className="flex flex-col gap-3">
            <p className="text-[20px]">Discount</p>
            <div className="border border-border rounded p-6">
              <p className="text-[20px] text-black/50">0%</p>
            </div>
          </div>

          <div className="flex flex-col gap-3">
            <p className="text-[20px]">Adjust Total</p>
            <div className="border border-border rounded p-6">
              <p className="text-[20px] text-black/50">$5,220 SGD</p>
            </div>
          </div>
        </div>

        {/* Download Button */}
        <button className="bg-[#202020] border border-black/25 rounded p-6 w-full text-[20px] text-white cursor-pointer hover:bg-[#333] transition-colors">
          Download Quote
        </button>
      </div>
    </div>
  );
}
