# ridermate_app

🏍️ RiderMate — Personal Ride Safety + AI Riding Coach

RiderMate is a smart ride-tracking and safety application designed for two-wheeler riders in India.
It helps riders stay safe, get real-time insights during their trip, and learn safer habits with the help of an AI Ride Coach powered by OpenAI.

RiderMate is built as a Flutter mobile + web app, with a custom Node.js backend for AI processing.


---

🚀 Features Overview

1️⃣ Live Ride Tracking

RiderMate tracks your ride using GPS and provides:

Live speed

Distance travelled

Ride duration

Overspeed alerts

Safety score

Ride summary after completion


Uses the geolocator plugin for accurate background location tracking.


---

2️⃣ Ride History

All completed rides are stored locally and shown in a history list:

Per-ride distance

Duration

Points earned

Overspeed events


Useful for weekly or monthly performance insights.


---

3️⃣ AI Ride Coach (Main Feature)

Your personal riding assistant who:

✔ Gives weekly & per-ride summaries

Total km

Overspeed events

Weekly points

Safety score (0–100)


✔ Recommends rest timing

Based on:

Continuous ride time

Fatigue indicators

Heat & weather (future upgrade)


✔ Suggests nearby petrol bunks

Based on your current location and estimated low-fuel situation.

✔ Suggests restaurants & special dishes

Localized food recommendations based on city/state.

✔ Gives proactive safety warnings

AI detects potential risks based on your stats:

School zones

Junctions

Wrong-way riding

Frequent overspeeding


✔ Ask AI anything

A chat-style interface where riders can ask:

“How do I ride safely at night?”

“When should I take a rest during long rides?”

“What food should I eat during a 150 km ride?”


All answers come from the RiderMate AI Coach backend.


---

4️⃣ Memories (Location + Note + Photo)

Capture moments from your ride:

Save location-tagged notes

Add photo memories (camera support planned)

Choose privacy: Public / Private / Friends

View memory list with timestamps and coordinates



---

5️⃣ Travel with Friends

A social tab designed for:

Adding friends

Seeing who is online

Planning group rides

Future: live friend tracking, invite links


(Currently UI-level, backend integration planned.)


---

6️⃣ Leaderboard & Referrals

Gamified system:

Earn points by riding safely

Climb leaderboard rankings

Refer friends using unique invite codes

Unlock future rewards


(Backend logic planned.)


---

7️⃣ App Branding

Custom RiderMate icon generated using:

flutter_launcher_icons

The app comes with:

Custom logo in /assets/logo/

Automatic icon generation for Android & iOS



---

🧠 AI Backend Architecture

RiderMate uses a Node.js (Express) backend located at:

/ridermate_backend

Backend Responsibilities

Receives ride stats + user questions

Builds a structured AI coaching prompt

Calls OpenAI Chat Completions API

Returns detailed, customized advice to the Flutter app


Endpoint

POST /ai-coach

Sample payload

{
  "stats": { ... },
  "question": "How to ride safely at night?",
  "location": { "lat": 12.97, "lon": 77.59 }
}

Response

{
  "answer": "Here’s how to ride safely at night..."
}


---

🏗️ Project Structure

lib/
  main.dart
  models/
    ride.dart
    chat_message.dart
    memory.dart
  services/
    ride_history_service.dart
    ai_coach_service.dart
    location_service.dart
  screens/
    home/
    ride/
    coach/
    history/
    memories/
    friends/
    leaderboard/
    referrals/
assets/
  logo/
ridermate_backend/
  index.js
  package.json
.github/
  workflows/
    build_apk.yml


---

💾 Running the App (Codespaces)

1. Export Flutter path

Run this in every new terminal:

export PATH="/workspaces/flutter/bin:$PATH"

2. Install dependencies

flutter pub get

3. Run the app (web server)

flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080

Codespaces will show a forwarded port that opens the app.


---

⚙️ Running the AI Backend

cd ridermate_backend
npm install
npm start

Backend runs on:

http://localhost:3000


---

📦 Building APK (GitHub Actions)

The repo includes:

.github/workflows/build_apk.yml

Every push to GitHub triggers:

Flutter installation

Dependency install

Icon generation

APK build

Artifact upload


Download your APK from GitHub Actions → Artifacts.


---

🏆 Why RiderMate Can Win Buildathons

Combines real-world safety + AI + mobility

Solves a real Indian problem (two-wheeler safety)

Looks polished with strong UI/UX

Has functioning AI backend

Can be shown live with working:

Ride tracking

AI chat

Summary insights

Memories system


Demonstrates full-stack skills:

Flutter

Node.js

OpenAI API

GitHub CI/CD




---

🧩 Future Enhancements

Real Google Maps tracking (Polyline + markers)

Firebase Auth (Google Sign-In)

Firebase Firestore for:

Friends

Leaderboards

Memories syncing


Real referral system

Push notifications for:

Overspeed

Rest reminder


Photo capture using image_picker or camera



---

🙌 Contributors

Rithwik K. R.
Founder & Developer of RiderMate


---

📄 License

This project is for educational and buildathon purposes.
Commercial licensing can be added later.
