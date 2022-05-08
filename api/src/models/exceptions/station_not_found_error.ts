export default class StationNotFoundError extends Error {
    constructor() {
        super("Station doesn't exist.");

        // Set the prototype explicitly.
        Object.setPrototypeOf(this, StationNotFoundError.prototype);
    }
}