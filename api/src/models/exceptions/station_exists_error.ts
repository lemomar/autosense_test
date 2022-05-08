export default class StationExistsError extends Error {
    constructor() {
        super("Station already exists.");

        // Set the prototype explicitly.
        Object.setPrototypeOf(this, StationExistsError.prototype);
    }
}