import StudyHeader from "../../components/study-header";
import SessionsCalendar from "../../components/sessions-calendar";

export default function SessionsPage() {
  return (
    <div className="flex-1 min-w-0">
      <StudyHeader
        statusLabel="Draft"
        dropdownLabel={null}
        urlDisplay={null}
      />
      <SessionsCalendar />
    </div>
  );
}
