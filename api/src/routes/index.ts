import { DocumentSnapshot } from 'firebase-admin/firestore';
import { Router } from "express";


import db from "../firebase";
import Station from '../models/station';

const router = Router();

router.get("/", async (req: any, res: any) => {
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

router.post("/new-station", async (req: any, res: any) => {
  const newStation: Station = req.body as Station;
  const doc = await db.collection("stations").doc(req.body.id).get();
  if (!doc.exists) {
    const id = req.body.id;
    delete newStation.id;
    await db.collection("stations").doc(id).set({ ...newStation });
    res.redirect("/");
  }
  else {
    res.status(400).json({ error: "There is already a station with that id." });
  }
});

router.get("/delete-station", async (req: any, res: any) => {
  const newStation: Station = req.body as Station;

  const doc = await db.collection("stations").doc(req.body.id).get();
  if (doc.exists) {
    await db.collection("stations").doc(newStation.id ?? "").delete();
    res.redirect("/");
  } else {
    res.status(400).json({ "error": "Station does not exist" });
  }
});

router.post("/update-station", async (req: any, res: any) => {
  const newStation: Station = req.body as Station;
  const { id: string } = newStation;
  const doc = await db.collection("stations").doc(req.body.id).get();
  if (doc.exists) {
    const id = req.body.id;
    delete newStation.id;
    await db
      .collection("stations")
      .doc(id)
      .update({ ...newStation });
    res.redirect("/");
  } else {
    res.status(400).json({ "error": "Station does not exist" });
  }
});

export default router;