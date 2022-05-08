import { DocumentSnapshot } from 'firebase-admin/firestore';
import { Router } from "express";


import db from "../firebase";
import Station from '../models/station';

const router = Router();

router.get("/", async (req:any, res:any) => {
  try {
    const querySnapshot = await db.collection("stations").get();
    const stations = querySnapshot.docs.map((doc: DocumentSnapshot) => ({
      id: doc.id,
      ...doc.data(),
    }));
    res.json({ stations });
  } catch (error) {
    console.error(error);
  }
});

router.post("/new-station", async (req:any, res:any) => {
  const newStation:Station = req.body as Station;
  await db.collection("stations").add({...newStation});
  res.redirect("/");
});

router.get("/delete-station", async (req:any, res:any) => {
  const newStation:Station = req.body as Station;
  await db.collection("stations").doc(newStation.id).delete();
  res.redirect("/");
});

router.post("/update-station", async (req:any, res:any) => {
  const newStation:Station = req.body as Station;
  await db
    .collection("stations")
    .doc(newStation.id)
    .update({ ...newStation });
  res.redirect("/");
});

export default router;