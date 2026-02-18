import StudyHeader from "../../components/study-header";
import PotentialMatchesScreening from "../../components/potential-matches-screening";
import ShareChannelCard from "../../components/share-channel-card";

const emailStats = [
  { label: "Delivered", value: "51", percentage: "95%", percentageColor: "green" as const },
  { label: "Opened", value: "12", percentage: "15%", percentageColor: "red" as const },
  { label: "Scheduled", value: "3", percentage: "4%", percentageColor: "red" as const },
];

const whatsappStats = [
  { label: "Delivered", value: "51", percentage: "95%", percentageColor: "green" as const },
  { label: "Opened", value: "12", percentage: "15%", percentageColor: "red" as const },
  { label: "Scheduled", value: "3", percentage: "4%", percentageColor: "red" as const },
];

export default function RecruitmentPage() {
  return (
    <div className="flex-1 min-w-0">
      <StudyHeader
        statusLabel="Recruiting"
        dropdownLabel={null}
        urlDisplay="https://recruit.research-network.co/singapore-bank-28193h"
      />
      <div className="flex flex-col gap-8 px-16 pb-16">
        <PotentialMatchesScreening />
        <div className="flex gap-8">
          <ShareChannelCard
            title="Share by Email"
            channelLabel="Share by email"
            buttonLabel="Send Email Campaign"
            stats={emailStats}
          />
          <ShareChannelCard
            title="Share by Whats App"
            channelLabel="Share by Whatsapp"
            buttonLabel="Open Message Composer"
            stats={whatsappStats}
          />
        </div>
      </div>
    </div>
  );
}
