import Pump from './pump';

export default interface Station {
  id: string | undefined;
  creatorId: string | undefined;
  name: string;
  address: string;
  city: string;
  latitude: number;
  longitude: number;
  pumps: Pump[];
}