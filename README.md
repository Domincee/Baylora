
# App Title
**Baylora**

## Team Members
* [Domince Aseberos] - SOLO


## App Description
Baylora is a modern marketplace and trading platform designed to facilitate seamless transactions between users. The application allows users to list items for sale, trade, or a combination of both (cash + trade). Key features include:
* **Multi-type Listings:** Support for Cash, Trade, and Mixed (Mix) transaction types.
* **Bidding System:** Real-time offer management where sellers can accept or reject bids.
* **User Profiles:** Verified profiles with ratings and trade history to build trust within the community.
* **Item Management:** Easy-to-use interface for posting, editing, and deleting listings with image support.
* **Secure Authentication:** Integrated Supabase authentication for user security.

## Screenshots of Major Screens


<img width="740" height="907" alt="image" src="https://github.com/user-attachments/assets/b29e2fbb-f535-4ec2-8a8b-f7d268b27031" />

<img width="736" height="870" alt="image" src="https://github.com/user-attachments/assets/520f81b3-cd0e-4a16-bee0-dc4b0761f53f" />
<img width="750" height="1334" alt="localhost_54759_(iPhone SE) (8)" src="https://github.com/user-attachments/assets/5bd25ed1-7160-4540-a3ad-3105eca89a8e" />

<img width="750" height="1334" alt="localhost_54759_(iPhone SE)" src="https://github.com/user-attachments/assets/8856c90f-fcd3-45ac-aac3-f17626966b83" />

<img width="750" height="1334" alt="localhost_54759_(iPhone SE) (2)" src="https://github.com/user-attachments/assets/8f9f97a8-6e9b-4670-a0d8-07d8f39849bb" />

<img width="750" height="1334" alt="localhost_54759_(iPhone SE) (9)" src="https://github.com/user-attachments/assets/4c712ac0-a734-46fc-8e84-82dcb5d6779f" />
<img width="750" height="1334" alt="localhost_54759_(iPhone SE) (10)" src="https://github.com/user-attachments/assets/5c864d8b-19f8-401e-bbb9-b596170a5e5b" />
<img width="750" height="1334" alt="localhost_54759_(iPhone SE) (3)" src="https://github.com/user-attachments/assets/9df03e5d-be19-41c5-b886-385a987a1d55" />
<img width="750" height="1334" alt="localhost_54759_(iPhone SE) (4)" src="https://github.com/user-attachments/assets/13979f41-a8e2-4b41-b8f2-bc13d50aa137" />
<img width="750" height="1334" alt="localhost_54759_(iPhone SE) (6)" src="https://github.com/user-attachments/assets/acb68bf8-6902-41dd-841f-efeaddadf987" />
<img width="750" height="1334" alt="localhost_54759_(iPhone SE) (7)" src="https://github.com/user-attachments/assets/279c8b05-7d5a-4a28-822b-4dc0a4d74aaf" />




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
