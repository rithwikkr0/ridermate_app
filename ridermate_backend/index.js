import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import fetch from "node-fetch";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;

app.post("/ai-coach", async (req, res) => {
  try {
    const { stats, question, location } = req.body || {};

    const cityInfo = location && location.lat && location.lon
      ? `The rider is approximately at latitude ${location.lat}, longitude ${location.lon}.`
      : `Location is approximate or unknown.`;

    const baseContext = `
You are RiderMate, an AI coach for two-wheeler riders in India.
Prioritise road safety, defensive riding, and practical advice.
Use simple, friendly language.

RIDE STATS (last 7 days):
- Total rides: ${stats?.totalRidesWeek}
- Total distance: ${stats?.totalKmWeek?.toFixed(2)} km
- Total overspeed events: ${stats?.totalOverspeedsWeek}
- Total points: ${stats?.totalPointsWeek}
- Safety score (0-100): ${stats?.safetyScore}

LAST RIDE:
- Distance: ${stats?.lastRideKm?.toFixed(2)} km
- Duration: ${stats?.lastRideMinutes} minutes
- Avg speed: ${stats?.lastRideAvgSpeed?.toFixed(1)} km/h
- Overspeed events: ${stats?.lastRideOverspeeds}

${cityInfo}

You must:
- Comment on riding style (safe / needs improvement / risky).
- Recommend when to take rest.
- Warn about overspeeding, school zones, junctions, wrong-route dangers.
- Suggest petrol bunk strategy (plan ahead, don't ride on reserve too long).
- Suggest light food / local specials for energy (avoid drowsiness).
`;

    const userPart = question
      ? `The rider asks: "${question}". Answer specifically for this rider.`
      : `No specific question. Give a helpful summary and 3-5 practical safety & rest tips for this rider.`;

    const messages = [
      { role: "system", content: baseContext },
      { role: "user", content: userPart },
    ];

    const response = await fetch(
      "https://api.openai.com/v1/chat/completions",
      {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${OPENAI_API_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "gpt-4o-mini",
          messages,
          temperature: 0.7,
        }),
      }
    );

    if (!response.ok) {
      const text = await response.text();
      console.error("OpenAI error:", text);
      return res
        .status(500)
        .json({ error: "OpenAI request failed", details: text });
    }

    const data = await response.json();
    const answer =
      data.choices?.[0]?.message?.content ||
      "I couldn't generate an answer right now.";

    res.json({ answer });
  } catch (err) {
    console.error("AI coach error:", err);
    res.status(500).json({ error: "Server error" });
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`RiderMate AI Coach backend listening on port ${port}`);
});
