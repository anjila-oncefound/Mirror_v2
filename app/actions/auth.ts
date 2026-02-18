"use server";

import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { redirect } from "next/navigation";

export type UserProfile = {
  id: string;
  name: string;
  email: string;
  role: string;
  is_active: boolean;
};

// Get the current logged-in user's profile
export async function getCurrentUser(): Promise<UserProfile | null> {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) return null;

  const { data } = await supabase
    .from("user_profiles")
    .select("id, name, email, role, is_active")
    .eq("id", user.id)
    .single();

  return data;
}

// Admin-only: invite a new user and create their profile
export async function inviteUser(formData: FormData) {
  const supabase = await createClient();

  // Verify the caller is an admin
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: caller } = await supabase
    .from("user_profiles")
    .select("role")
    .eq("id", user.id)
    .single();

  if (caller?.role !== "admin") {
    return { error: "Only admins can invite users" };
  }

  const name = formData.get("name") as string;
  const email = formData.get("email") as string;
  const role = formData.get("role") as string;

  if (!name || !email || !role) {
    return { error: "Name, email, and role are required" };
  }

  const validRoles = ["admin", "manager", "client", "member"];
  if (!validRoles.includes(role)) {
    return { error: `Invalid role. Must be one of: ${validRoles.join(", ")}` };
  }

  const admin = createAdminClient();

  // Create auth user and send invite email
  const { data: authData, error: authError } =
    await admin.auth.admin.inviteUserByEmail(email, {
      data: { name, role },
    });

  if (authError) {
    return { error: authError.message };
  }

  // Create the user_profiles row
  const { error: profileError } = await admin.from("user_profiles").insert({
    id: authData.user.id,
    name,
    email,
    role,
  });

  if (profileError) {
    // Rollback: delete the auth user if profile creation fails
    await admin.auth.admin.deleteUser(authData.user.id);
    return { error: profileError.message };
  }

  return { success: true };
}

// Sign out
export async function signOut() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/login");
}
