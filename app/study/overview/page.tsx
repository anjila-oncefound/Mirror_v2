import StudyHeader from "../../components/study-header";
import RecentActivity from "../../components/recent-activity";
import RecruitmentPipeline from "../../components/recruitment-pipeline";
import DailyEngagement from "../../components/daily-engagement";

export default function OverviewPage() {
  return (
    <div className="flex-1 min-w-0">
      <StudyHeader statusLabel="Draft" dropdownLabel={null} />
      <div className="flex flex-col gap-8 px-16 pb-16">
        <RecentActivity />
        <RecruitmentPipeline />
        <DailyEngagement />
      </div>
    </div>
  );
}
