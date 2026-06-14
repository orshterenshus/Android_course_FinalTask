# Kids' Books 📚

A clean, modular Flutter (Android) application for **uploading and downloading
children's books**, organized by age group and file format. Built as a final
academic project.

Parents/teachers can browse books by the child's age (0–4, 4–8, 8–12) and by
format (Word or PDF), download a book to the device, open it in the system
viewer, and upload new books — with the file picker strictly restricted to the
correct format for each category.

The backend is **Supabase** (free, no credit card): a Postgres database for the
book metadata and Supabase Storage for the actual files.

---

## ✨ Features

- **Home screen** — "Choose your child's age" with six colorful, kid-friendly
  cards laid out in two columns (Word | PDF), each column headed by its format
  icon.
- **Category screen** — list of books from the database. Each row has a smart
  action button:
  - **GET** when the file is not on the device,
  - a **circular progress spinner** while downloading,
  - **OPEN** once downloaded (launches the device's default viewer).
- **Upload Book** — bottom button that opens the native file picker
  **restricted to `.doc`/`.docx` in Word categories and `.pdf` in PDF
  categories**, uploads the file to Supabase Storage and saves its metadata to
  the database.

---

## 🏗️ Architecture

A simple, layered, testable structure using **Provider** for state management:

```
lib/
├── main.dart                  # Supabase init, theme, home route
├── core/
│   ├── enums.dart             # AgeGroup & FileType (labels, icons, extensions)
│   ├── theme.dart             # Kid-friendly global theme & palette
│   └── supabase_config.dart   # Your Supabase URL + key (you fill these in)
├── models/
│   └── book.dart              # Book metadata + JSON (de)serialization
├── services/                  # All I/O isolated here (easy to mock/test)
│   ├── database_service.dart  # Book metadata CRUD (Supabase Postgres)
│   ├── storage_service.dart   # File uploads to Supabase Storage
│   └── download_service.dart  # dio download + local save + open_filex
├── providers/                 # ChangeNotifiers — the reactive state
│   ├── books_provider.dart    # Per-category list + per-book download state
│   └── upload_provider.dart   # Restricted file pick + upload flow
├── screens/
│   ├── home_screen.dart       # The six category cards
│   └── category_screen.dart   # Book list + Upload Book bar
└── widgets/
    ├── category_card.dart     # One colorful home-screen card
    ├── book_list_tile.dart    # One book row
    └── action_button.dart     # GET / spinner / OPEN button
```

**Why Provider?** For an app of this size it gives clean, idiomatic reactive
state with minimal boilerplate, is officially recommended by the Flutter team,
and is easy to explain in a project defense. Each screen owns its providers, so
their lifecycle is tied to that screen.

---

## 📦 Dependencies

| Package            | Purpose                                  |
| ------------------ | ---------------------------------------- |
| `supabase_flutter` | Database + file storage backend          |
| `provider`         | State management                         |
| `file_picker`      | Pick files (restricted by extension)     |
| `path_provider`    | Locate the local documents directory     |
| `dio`              | Download files with progress             |
| `open_filex`       | Open downloaded files in the OS viewer   |

---

## 🚀 Getting started

See **[SETUP_GUIDE.md](SETUP_GUIDE.md)** for the full step-by-step guide. In short:

1. **Install packages**
   ```bash
   flutter pub get
   ```
2. **Create a free Supabase project** at <https://supabase.com> (no credit card).
3. **Paste your credentials** into `lib/core/supabase_config.dart`
   (Project URL + publishable/anon key).
4. **Run the SQL script** from SETUP_GUIDE.md in the Supabase SQL Editor — it
   creates the `books` table, the storage bucket, and the access rules.
5. **Run**
   ```bash
   flutter run
   ```

---

## 🗃️ Data model

Each book is one row in the Supabase `books` table:

| Column         | Type        | Example                              |
| -------------- | ----------- | ------------------------------------ |
| `id`           | uuid        | auto-generated                       |
| `title`        | text        | `"Book 1"`                           |
| `download_url` | text        | Supabase Storage public URL          |
| `storage_path` | text        | `0-4/word/1700000000_a.docx`         |
| `file_name`    | text        | `"a.docx"`                           |
| `age_group`    | text        | `"0-4"`, `"4-8"`, `"8-12"`           |
| `file_type`    | text        | `"word"` or `"pdf"`                  |
| `created_at`   | timestamptz | server time (used for ordering)      |

Files in Storage are organized as `<ageGroup>/<fileType>/<timestamp>_<name>`.
Downloads are saved to the app's private documents directory under `books/`.
