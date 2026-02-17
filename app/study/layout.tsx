import NotificationBar from "../components/notification-bar";
import Sidebar from "../components/sidebar";
import TabNavigation from "../components/tab-navigation";

export default function StudyLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="bg-background flex flex-col min-h-screen">
      <NotificationBar />
      <div className="flex flex-1">
        <Sidebar />
        <div className="flex flex-col flex-1 min-w-0">
          <TabNavigation />
          {children}
        </div>
      </div>
    </div>
  );
}
