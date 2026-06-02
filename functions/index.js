const functions = require("firebase-functions");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();
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
const customerName = body.customer_name;
const customerEmail = body.customer_email;
const customerPhone = body.customer_phone;

    console.log("Amount:", amount);
    const orderId = "order_" + Date.now();

    const response = await axios.post(
      "https://api.cashfree.com/pg/orders",
      {
        order_id: orderId,
        order_amount: amount,
        order_currency: "INR",
       customer_details: {
  customer_id: customerPhone,
  customer_name: customerName,
  customer_email: customerEmail,
  customer_phone: customerPhone
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

exports.sendOrderNotification = onDocumentCreated(
  "orders/{orderId}",
  async (event) => {
    try {
      const db = admin.firestore();

      const adminDoc = await db
        .collection("admin")
        .doc("settings")
        .get();

      if (!adminDoc.exists) {
        console.log("Admin token not found");
        return;
      }

      const token = adminDoc.data().token;

      await admin.messaging().send({
        token: token,
        notification: {
          title: "New Order",
          body: "A new order has arrived",
        },
      });

      console.log("Notification sent successfully");
    } catch (e) {
      console.error("Notification Error:", e);
    }
  }
);
exports.sendBookingNotification = onDocumentCreated(
  "bookings/{bookingId}",
  async (event) => {
    try {
      const db = admin.firestore();

      const adminDoc = await db
        .collection("admin")
        .doc("settings")
        .get();

      if (!adminDoc.exists) return;

      const token = adminDoc.data().token;

      await admin.messaging().send({
        token: token,
        notification: {
          title: " New Booking",
          body: "A new booking has arrived",
        },
        android: {
          priority: "high",
          notification: {
            sound: "order_sound",
          },
        },
      });

      console.log("Booking notification sent");
    } catch (e) {
      console.error("Booking notification error:", e);
    }
  }
);