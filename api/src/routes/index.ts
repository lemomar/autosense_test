import { DocumentSnapshot } from 'firebase-admin/firestore';
import { Router } from "express";
import axios from 'axios';


import db from "../firebase";
import Station from '../models/station';
import StationExistsError from '../models/exceptions/station_exists_error';
import StationNotFoundError from '../models/exceptions/station_not_found_error';

const router = Router();

router.get("/", async (req: any, res: any) => {
  try {
    const querySnapshot = await db.collection("stations").get();
    const stations = querySnapshot.docs.map((doc: DocumentSnapshot) => ({
      id: doc.id,
      ...doc.data(),
    }));
    res.status(200).json({ stations });
  } catch (error) {
    res.status(400).json({ error: "An error occured. Please try again." });
  }
});

router.post("/new-station", async (req: any, res: any) => {
  try {
    const newStation: Station = req.body as Station;
    const doc = await db.collection("stations").doc(req.body.id).get();
    if (doc.exists) throw new StationExistsError();
    const resultsFromGMaps = await axios.get(`https://maps.googleapis.com/maps/api/geocode/json?latlng=${req.body.latitude},${req.body.longitude}&key=${process.env.GMAPP_API_KEY}`);
    newStation.city = resultsFromGMaps.data.results.find((element: any) => element.types.includes("locality"))?.address_components[0]?.long_name || "";
    newStation.address = resultsFromGMaps.data.results.find((element: any) => element.types.includes("plus_code"))?.formatted_address || "";
    const id = req.body.id;
    delete newStation.id;
    await db.collection("stations").doc(id).set({ ...newStation });
    res.redirect("/");
  } catch (error) {
    if (error instanceof StationExistsError) {
      res.status(400).json({ error: error.message });
      return;
    }
    console.log(error);
    res.status(400).json({ error: "An error occured. Please try again." });
  }
});

router.delete("/delete-station", async (req: any, res: any) => {
  try {
    const newStation: Station = req.body as Station;

    const doc = await db.collection("stations").doc(req.body.id).get();
    if (!doc.exists) throw new StationNotFoundError();
    await db.collection("stations").doc(newStation.id ?? "").delete();
    res.redirect("/");
  } catch (error) {
    if (error instanceof StationNotFoundError) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(400).json({ error: "An error occured. Please try again." });
  }
});

router.post("/update-station", async (req: any, res: any) => {
  try {
    const newStation: Station = req.body as Station;
    const { id: string } = newStation;
    const doc = await db.collection("stations").doc(req.body.id).get();
    if (!doc.exists) throw new StationNotFoundError();
    const id = req.body.id;
    delete newStation.id;
    await db
      .collection("stations")
      .doc(id)
      .update({ ...newStation });
    res.redirect("/");
  } catch (error) {
    if (error instanceof StationNotFoundError) {
      res.status(400).json({ error: error.message });
      return;
    }
    res.status(400).json({ error: "An error occured. Please try again." });
  }
});

export default router;