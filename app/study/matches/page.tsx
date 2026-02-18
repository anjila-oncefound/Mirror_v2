import StudyHeader from "../../components/study-header";
import MatchesTable from "../../components/matches-table";

export default function MatchesPage() {
  return (
    <div className="flex-1 min-w-0">
      <StudyHeader
        statusLabel="Draft"
        dropdownLabel="Persona A"
        urlDisplay={null}
      />
      <MatchesTable />
    </div>
  );
}
