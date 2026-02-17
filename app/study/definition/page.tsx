import StudyHeader from "../../components/study-header";
import AudienceSegment from "../../components/audience-segment";
import ProjectSpecificQuestions from "../../components/project-specific-questions";
import SegmentationPanel from "../../components/segmentation-panel";

export default function DefinitionPage() {
  return (
    <div className="flex-1 min-w-0">
      <StudyHeader statusLabel="Draft" dropdownLabel="Segments: Singapore" />
      <div className="flex gap-8 px-16 pb-16">
        <div className="flex flex-col gap-8 flex-1 min-w-0">
          <AudienceSegment />
          <ProjectSpecificQuestions />
        </div>
        <SegmentationPanel />
      </div>
    </div>
  );
}
