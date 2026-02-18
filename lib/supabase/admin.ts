import { createClient } from "@supabase/supabase-js";

// Server-only client using the secret key.
// Bypasses RLS — use only in server actions for admin operations.
export function createAdminClient() {
  return createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SECRET_KEY!
  );
}
