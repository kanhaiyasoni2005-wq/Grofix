const functions = require("firebase-functions");
const axios = require("axios");

const APP_ID = "125825905a3840f59fac80c005e9528521";
const SECRET_KEY = "cfsk_ma_prod_ef3b665aed5f30f600ebbdbb8d1538bb_cf3d7a2f";

exports.createOrder = functions.https.onRequest({ invoker: "public" }, async (req, res) => {
  // Handle CORS
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, POST');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  try {
     console.log("🔥 NEW CODE RUNNING");
    // 🔥 FIX: body safely read karo
    const body = req.body || JSON.parse(req.rawBody || "{}");
    const amount = body.amount;

    console.log("Amount:", amount);
    const orderId = "order_" + Date.now();

    const response = await axios.post(
      "https://api.cashfree.com/pg/orders",
      {
        order_id: orderId,
        order_amount: amount,
        order_currency: "INR",
        customer_details: {
          customer_id: "user123",
          customer_phone: "9999999999"
        }
      },
      {
        headers: {
          "Content-Type": "application/json",
          "x-client-id": "125825905a3840f59fac80c005e9528521",
          "x-client-secret": "cfsk_ma_prod_ef3b665aed5f30f600ebbdbb8d1538bb_cf3d7a2f",
          "x-api-version": "2022-09-01"
        }
      }
    );

    res.json(response.data);

  } catch (e) {
    console.error("ERROR:", e.response?.data || e.message);

    res.status(500).json({
      error: e.response?.data || e.message
    });
  }
});