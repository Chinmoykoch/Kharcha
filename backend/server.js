import express from "express";
import dotenv from "dotenv";
import { ChatGoogleGenerativeAI } from "@langchain/google-genai";
import { HumanMessage } from "@langchain/core/messages";

dotenv.config();

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

async function fetchImageAsBase64(imageUrl) {
  const response = await fetch(imageUrl);
  if (!response.ok) {
    throw new Error(`Failed to fetch image: ${response.statusText}`);
  }
  const arrayBuffer = await response.arrayBuffer();
  const base64String = Buffer.from(arrayBuffer).toString("base64");
  const mimeType = response.headers.get("content-type") || "image/jpeg";

  // Convert to a proper Data URL format
  return `data:${mimeType};base64,${base64String}`;
}

async function scanReceipt(imageUrl) {
  try {
    const model = new ChatGoogleGenerativeAI({
      model: "gemini-1.5-flash",
      apiKey: "AIzaSyB6IPeTsMyQXyuA1gopMgO48z0VBf1tbP0", // Use env variable for security
      temperature: 0.2,
    });

    const base64DataUrl = await fetchImageAsBase64(imageUrl);

    const messages = [
      new HumanMessage({
        content: [
          {
            type: "text",
            text: `
              Analyze this receipt image and extract the following information in JSON format:
              - Total amount (just the number)
              - Date (in ISO format)
              - Description or items purchased (brief summary)
              - Merchant/store name
              - Suggested category (one of: housing, transportation, groceries, utilities, entertainment, food, shopping, healthcare, education, personal, travel, insurance, gifts, bills, other-expense)
              
              Respond only with valid JSON:
              {
                "amount": number,
                "date": "YYYY-MM-DD",
                "description": "string",
                "merchantName": "string",
                "category": "string"
              }
            `,
          },
          {
            type: "image_url",
            image_url: base64DataUrl, // ✅ Corrected format
          },
        ],
      }),
    ];

    const result = await model.invoke(messages);
    
    // Parse JSON response
    const responseText = result.content.replace(/```json\n?|```/g, "").trim();
    return JSON.parse(responseText);
  } catch (error) {
    console.error("Error scanning receipt:", error);
    throw new Error("Failed to scan receipt");
  }
}
// API route for receipt scanning
app.post("/scan-receipt", async (req, res) => {
  try {
    const { imageUrl } = req.body;
    if (!imageUrl) return res.status(400).json({ error: "Image URL is required" });

    const receiptData = await scanReceipt(imageUrl);
    res.json(receiptData);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

console.log("Starting the server...");
app.listen(9000, () => {
  console.log(`Server running on port 9000 ⚙️`);
});

export default app;
