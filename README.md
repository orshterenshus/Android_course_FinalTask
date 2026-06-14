# Android Course – Final Task

This repository contains two separate Flutter (Android) projects built for the
Android course. Each lives in its own folder and is a standalone Flutter app.

```
Android_course_FinalTask/
├── KidsBooks/   # "Kids' Books" – upload/download children's books (Supabase backend)
└── Lec6/        # Lecture 6 class exercises – a set of demo screens
```

## KidsBooks

A modular Flutter app for uploading and downloading children's books, organized
by age group (0–4, 4–8, 8–12) and file format (Word / PDF). The backend is
Supabase (Postgres for metadata + Storage for the files).

See [`KidsBooks/README.md`](KidsBooks/README.md) and
[`KidsBooks/SETUP_GUIDE.md`](KidsBooks/SETUP_GUIDE.md) for full details.

## Lec6

The Lecture 6 class exercises in a single app behind a launcher menu:

1. **Phone login** – phone entry → OTP verification (two screens)
2. **Download apps** – list with GET → progress spinner → OPEN (dummy)
3. **Service dashboard** – grid + right-arrow button opening a second menu
4. **Bottom navigation** – Home / Settings / Profile tabs
5. **Profile** – photo (tap to view full-screen), contact details, social links
6. **Settings** – toggle switches (Dark Mode is fully functional)
6b. **Resume / items** – item list with upload buttons

## Running either project

Each folder is an independent Flutter project:

```bash
cd KidsBooks   # or: cd Lec6
flutter pub get
flutter run
```
