import { getCurrentUser } from "../actions/auth";
import NotificationBar from "../components/notification-bar";
import Sidebar from "../components/sidebar";
import TabNavigation from "../components/tab-navigation";

export default async function StudyLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const user = await getCurrentUser();

  return (
    <div className="bg-background flex flex-col min-h-screen">
      <NotificationBar />
      {/* TODO: remove after verifying auth works */}
      {user && (
        <div className="bg-neutral-900 text-neutral-400 text-xs px-4 py-2 border-b border-neutral-800">
          Logged in as <span className="text-white font-medium">{user.name}</span> ({user.role})
        </div>
      )}
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
