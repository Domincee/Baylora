## [1.2.0] - 2026-01-04

### 🚀 Features
- **Global Timer Logic:** Introduced `DateUtil` to handle countdown calculations consistently across the app.
- **Home Feed:** `ItemCard` now displays a "Red Pill" (e.g., "2h left") for items ending soon.
- **Profile Redesign:**
    - Replaced infinite scrolling list with a **"Recent Listings"** preview (Max 4 items).
    - Added a smart **"See All"** button that auto-hides if the user has few items.
    - `ManagementListingCard` now supports duration indicators.

### 🐛 Bug Fixes
- **Ghost Timers:** Fixed an issue in `CreateListingScreen` where items created without a duration still saved an `end_time` in the database.

### ♻️ Refactoring
- **Architecture:** Decoupled color logic into `app_listing_colors.dart` to safely allow custom Status Badge colors (Cyan for Accepted, Red for Ended).
- **Clean Code:** Centralized all Profile-related strings to `ProfileStrings.dart`.

### ⚙️ Backend
- **Automation:** Implemented Supabase `pg_cron` job to automatically mark items as 'ended' when their time expires.