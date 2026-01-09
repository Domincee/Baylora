# Baylora App Documentation

## App Title
**Baylora**

## Team Members
* [Add Team Member Name] - Lead Developer / UI Designer
* [Add Team Member Name] - Backend / Database Architect
* [Add Team Member Name] - Quality Assurance

## App Description
Baylora is a modern marketplace and trading platform designed to facilitate seamless transactions between users. The application allows users to list items for sale, trade, or a combination of both (cash + trade). Key features include:
* **Multi-type Listings:** Support for Cash, Trade, and Mixed (Mix) transaction types.
* **Bidding System:** Real-time offer management where sellers can accept or reject bids.
* **User Profiles:** Verified profiles with ratings and trade history to build trust within the community.
* **Item Management:** Easy-to-use interface for posting, editing, and deleting listings with image support.
* **Secure Authentication:** Integrated Supabase authentication for user security.

## Screenshots of Major Screens
| Splash & Onboarding | Login / Register | Home / Marketplace |
|:---:|:---:|:---:|
| ![Placeholder] | ![Placeholder] | ![Placeholder] |
| *Initial App Experience* | *User Access* | *Item Discovery* |

| Item Details | Manage Listings | User Profile |
|:---:|:---:|:---:|
| ![Placeholder] | ![Placeholder] | ![Placeholder] |
| *Product Info & Bidding* | *Seller Dashboard* | *Reputation & Settings* |

## Database Structure (Supabase/PostgreSQL)

The application utilizes Supabase for real-time data and storage. Key tables include:

### 1. `items` Table
* `id` (UUID): Unique identifier for the listing.
* `title` (String): Name of the item.
* `description` (Text): Detailed information about the item.
* `price` (Numeric): Asking price (if applicable).
* `type` (String): Transaction type (`cash`, `trade`, `mix`).
* `swap_preference` (String): What the seller wants in exchange (for trades).
* `images` (List<String>): Array of URLs stored in Supabase Storage.
* `status` (String): Current state (`active`, `sold`, `deleted`).
* `end_time` (Timestamp): Expiration of the listing.
* `profiles_id` (FK): Reference to the seller.

### 2. `profiles` Table
* `id` (UUID): Reference to Supabase Auth user.
* `username` (String): Display name.
* `avatar_url` (String): Profile picture link.
* `rating` (Numeric): User's average rating.
* `total_trades` (Integer): Number of successful transactions.
* `is_verified` (Boolean): Verification badge status.

### 3. `offers` Table
* `id` (UUID): Unique identifier for the bid.
* `item_id` (FK): The listing being bid on.
* `status` (String): `pending`, `accepted`, or `rejected`.
* `bidder_id` (FK): User making the offer.

## Tech Stack Used
* **Frontend:** Flutter (Dart)
* **State Management:** Riverpod
* **Backend as a Service (BaaS):** Supabase
    * **Database:** PostgreSQL
    * **Authentication:** Supabase Auth
    * **Storage:** Supabase Storage (for item images)
* **UI/UX Components:**
    * **Fonts:** Poppins (Title), Nunito Sans (Body), Montserrat Alternates (Logo)
    * **Icons:** Cupertino Icons, Flutter SVG
    * **Feedback:** Flutter EasyLoading
* **Utilities:** 
    * `flutter_dotenv` for environment variables.
    * `image_picker` for media uploads.
    * `timeago` for relative timestamps.
