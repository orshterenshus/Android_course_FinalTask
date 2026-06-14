# Kids' Books — Setup, Run & Supabase Guide

A step-by-step guide for **(A) opening and running the app** and **(B) connecting
it to your own free Supabase backend** so uploads and downloads work.

The backend is **Supabase** — free, and **no credit card required**. It gives
you both a database (Postgres) for the book metadata and file storage (1 GB
free) for the actual `.pdf` / `.docx` files.

Everything else (Flutter, JDK 17, Android SDK, an emulator named `pixel_kids`,
Node.js, VS Code) is already installed on this machine. Paths assume the project
lives at:

```
C:\Users\Or Shterenshus\Desktop\kids_books
```

---

# PART A — How to open and run the code

## A1. Open the project in VS Code
1. Open **VS Code**.
2. **File → Open Folder…** → choose `C:\Users\Or Shterenshus\Desktop\kids_books`.
3. (First time only) Install the **Flutter** extension when prompted.
4. The app code is in `lib/`. The entry point is `lib/main.dart`.

## A2. Start the Android emulator
Open a terminal (VS Code: **Terminal → New Terminal**) and run:

```powershell
C:\Android\sdk\emulator\emulator.exe -avd pixel_kids
```

Wait until the phone finishes booting. Leave this terminal open.

## A3. Run the app
Open a **second** terminal:

```powershell
cd "C:\Users\Or Shterenshus\Desktop\kids_books"
flutter run
```

While running: **r** = hot reload, **R** = hot restart, **q** = quit.
(Or in VS Code, press **F5**.)

**Before you do Part B, the app opens to the home screen and you can navigate,
but categories show "Could not load books" and uploads fail — that's expected
until you connect Supabase below.**

---

# PART B — Connect your own free Supabase backend

You do this **once**.

## B1. Create the Supabase project (free, no card)
1. Go to <https://supabase.com> → **Start your project** → sign in (GitHub or
   email).
2. **New project**. Give it a name (e.g. `kids-books`), set a database password
   (save it somewhere), pick a region near you, and create it.
3. Wait ~2 minutes for it to finish provisioning.

## B2. Copy your two credentials into the app
1. In the Supabase dashboard: gear icon (**Project Settings**) → **API Keys**
   (and the **Data API**/**General** tab for the URL).
2. You need two values:
   - **Project URL** — looks like `https://abcdefghijklmnop.supabase.co`
   - **Publishable key** (older dashboards label this **anon public**) — a long
     string.
3. Open **`lib/core/supabase_config.dart`** and paste them in:
   ```dart
   static const String supabaseUrl = 'https://abcdefghijklmnop.supabase.co';
   static const String supabaseKey = 'paste-your-publishable-key-here';
   ```
   Save the file. **This is the only file you edit by hand.**

## B3. Create the table, storage bucket, and access rules
1. In the Supabase dashboard, open the **SQL Editor** (left sidebar) → **New
   query**.
2. Paste the entire script below and click **Run**.

```sql
-- ============================================================
-- Kids' Books — one-time backend setup
-- ============================================================

-- 1. The book metadata table
create table if not exists public.books (
  id           uuid primary key default gen_random_uuid(),
  title        text        not null,
  download_url text        not null,
  storage_path text        not null,
  file_name    text        not null,
  age_group    text        not null,
  file_type    text        not null,
  created_at   timestamptz not null default now()
);

-- 2. Row Level Security: allow anyone to read and add books.
--    (Permissive on purpose for an academic/demo app with no login.)
alter table public.books enable row level security;

create policy "Public read books"
  on public.books for select
  using (true);

create policy "Public insert books"
  on public.books for insert
  with check (true);

-- 3. A PUBLIC storage bucket for the actual files
insert into storage.buckets (id, name, public)
values ('books', 'books', true)
on conflict (id) do nothing;

-- 4. Allow anyone to read and upload files in that bucket
create policy "Public read book files"
  on storage.objects for select
  using (bucket_id = 'books');

create policy "Public upload book files"
  on storage.objects for insert
  with check (bucket_id = 'books');

-- 5. Allow the app to delete books and their files (for the delete button)
create policy "Public delete books"
  on public.books for delete
  using (true);

create policy "Public delete book files"
  on storage.objects for delete
  using (bucket_id = 'books');
```

That creates everything the app needs: the `books` table, a public `books`
storage bucket, and permissive rules so the app can read/write without a login.

## B4. Run it and test the full flow
```powershell
flutter run
```

Now you can:
- Tap a category (e.g. **Ages 0-4 → PDF**).
- Tap **Upload Book**, name it — the file picker opens **restricted to the
  right type** (`.pdf` in PDF categories, `.doc`/`.docx` in Word categories).
- After upload, the book appears with a **GET** button → tap to download
  (spinner shows progress) → it becomes **OPEN** → tap to view the file.

You can watch your data arrive in the Supabase dashboard under **Table Editor →
books** and **Storage → books**.

---

# Quick reference (every time you want to run it)

```powershell
# 1) start the emulator (leave open)
C:\Android\sdk\emulator\emulator.exe -avd pixel_kids

# 2) in another terminal, run the app
cd "C:\Users\Or Shterenshus\Desktop\kids_books"
flutter run
```

# Troubleshooting
- **"Could not load books":** check that `supabaseUrl` / `supabaseKey` in
  `lib/core/supabase_config.dart` are correct and that you ran the SQL in B3.
- **Upload fails:** make sure the SQL in B3 ran without errors (it creates the
  bucket and the upload policy).
- **`flutter` not recognized:** open a brand-new terminal (PATH only updates for
  new terminals). The SDK is at `C:\src\flutter\bin`.
- **No devices found:** make sure the emulator finished booting
  (`flutter devices`).
- **Build warnings about Gradle/AGP/Kotlin versions:** these are deprecation
  *warnings*, not errors. The versions (AGP 8.9.1 / Gradle 8.11.1 /
  Kotlin 2.1.0) are pinned deliberately for `file_picker` compatibility.
