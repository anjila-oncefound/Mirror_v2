import StudyHeader from "../../components/study-header";
import ProjectDetailsCard from "../../components/project-details-card";
import TotalProjectCost from "../../components/total-project-cost";
import FinalizeQuote from "../../components/finalize-quote";

export default function QuotationPage() {
  return (
    <div className="flex-1 min-w-0">
      <StudyHeader statusLabel="Quoting" dropdownLabel="Draft" />
      <div className="flex gap-8 px-16 pb-16">
        {/* Left: Main content card */}
        <div className="flex-1 min-w-0">
          <ProjectDetailsCard />
        </div>

        {/* Right: Sidebar */}
        <div className="w-[540px] shrink-0 flex flex-col gap-8">
          <TotalProjectCost />
          <FinalizeQuote />
        </div>
      </div>
    </div>
  );
}
