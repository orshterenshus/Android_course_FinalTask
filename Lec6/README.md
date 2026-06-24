# Lec6 – Class Exercises

A single Flutter app that implements all of the **Lecture 6 class exercises**.
The app opens on a launcher menu (`home_menu_screen.dart`) from which each
exercise can be opened on its own screen.

> Source spec: `Lec6_ClassExercises.pptx` (Ver 1.0)

## Running

```bash
cd Lec6
flutter pub get
flutter run
```

(An Android emulator or a connected device must be running first.)

## Project structure

```
lib/
├── main.dart                 # App entry point + theming (light/dark)
├── theme.dart                # Brand color, light & dark themes, themeNotifier
├── screens/
│   ├── home_menu_screen.dart        # Launcher menu linking to every exercise
│   ├── ex1_phone_entry_screen.dart  # Exercise 1 – phone entry
│   ├── ex1_otp_screen.dart          # Exercise 1 – OTP verification
│   ├── ex2_download_screen.dart     # Exercise 2 – download items (dummy)
│   ├── ex3_service_dashboard_screen.dart  # Exercise 3 – dashboard
│   ├── ex3_second_menu_screen.dart  # Exercise 3 – second menu (with back)
│   ├── ex4_bottom_nav_screen.dart   # Exercise 4 – bottom navigation
│   ├── ex5_profile_screen.dart      # Exercise 5 – profile
│   ├── ex6_settings_screen.dart     # Exercise 6 – settings (toggles)
│   └── ex6b_resume_screen.dart      # Exercise 6 (part b) – items list
└── widgets/
    └── services_grid.dart    # Reusable services grid (shared by Ex3 & Ex4)
```

## Exercises

### Exercise 1 — Phone login
> *Create two new screens to login with phone number.*

Two screens: a phone-number entry screen → an OTP verification screen.
- `screens/ex1_phone_entry_screen.dart`
- `screens/ex1_otp_screen.dart`

### Exercise 2 — Download items
> *Create a new screen to download items. This is only a dummy screen — no actual download occurs.*

A list of items, each with a `GET` button → progress spinner → `OPEN`
(simulated, no real download).
- `screens/ex2_download_screen.dart`

### Exercise 3 — Dashboard
> *Create a new Dashboard screen. On right-button click another menu appears. Add a back button on the second screen.*

A dashboard with a right-arrow button that opens a second menu; the second
screen has a working back button.
- `screens/ex3_service_dashboard_screen.dart`
- `screens/ex3_second_menu_screen.dart`

### Exercise 4 — Bottom navigation
> *Duplicate the previous screen. Add a BottomNavigationBar with 3 tabs (Home, Settings, Profile), each with different content.*

The dashboard with a bottom navigation bar switching between Home, Settings
and Profile content (reuses the Ex5 / Ex6 bodies).
- `screens/ex4_bottom_nav_screen.dart`

### Exercise 5 — Profile
> *Create a profile screen with your photo, contact details and social account links.*

Profile screen with a tappable photo (opens full-screen), contact details and
social links.
- `screens/ex5_profile_screen.dart`

### Exercise 6 — Settings
> *Create a Settings screen with three toggle buttons. Navigation should work from the Dashboard (Home / Settings / Profile).*

A settings screen with three toggle switches. The **Dark Mode** toggle is fully
functional and switches the whole app between light and dark themes.
- `screens/ex6_settings_screen.dart`

### Exercise 6 (part b) — Items screen
> *Add a screen with items as in the screenshot.*

An additional items list screen with upload buttons.
- `screens/ex6b_resume_screen.dart`
