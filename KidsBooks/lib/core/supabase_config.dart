/// Supabase project credentials.
///
/// =============================================================================
/// REPLACE THE TWO PLACEHOLDER VALUES BELOW WITH YOUR OWN PROJECT'S VALUES.
/// =============================================================================
///
/// Where to find them:
///   1. Go to https://supabase.com and open your project.
///   2. Click the gear icon → "Project Settings" → "API Keys".
///   3. Copy "Project URL" into [supabaseUrl].
///   4. Copy the "publishable" key (older dashboards call it the "anon public"
///      key) into [supabaseKey].
///
/// This key is safe to ship in a client app — it only grants the access you
/// allow through your Row Level Security policies (see SETUP_GUIDE.md).
///
/// Full step-by-step instructions are in SETUP_GUIDE.md.
/// =============================================================================
class SupabaseConfig {
  SupabaseConfig._(); // Not instantiable.

  /// Your project URL, e.g. `https://abcdefghijklmnop.supabase.co`.
  static const String supabaseUrl = 'https://ogxvvukwvdmbfejaqqqa.supabase.co';

  /// Your project's public key ("publishable" / "anon public").
  static const String supabaseKey = 'sb_publishable_KpeIRf_drdNN49OiNh5v9A_Dmdr5Tsu';

  /// Name of the Storage bucket that holds the uploaded book files.
  /// Created by the SQL script in SETUP_GUIDE.md.
  static const String booksBucket = 'books';

  /// Name of the database table that holds the book metadata.
  static const String booksTable = 'books';
}
