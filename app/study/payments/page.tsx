import StudyHeader from "../../components/study-header";
import PaymentsTable from "../../components/payments-table";

export default function PaymentsPage() {
  return (
    <div className="flex-1 min-w-0">
      <StudyHeader
        statusLabel="Draft"
        dropdownLabel={null}
        urlDisplay={null}
      />
      <PaymentsTable />
    </div>
  );
}
