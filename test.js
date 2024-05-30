function validateInput(objectNotes) {
    if (Array.isArray(objectNotes)) {
        throw new Error('Error: Input is not an object');
    }
    if (Object.keys(objectNotes).length === 0) {
        throw new Error('Error: Object is empty');
    }
}

function validateKeyValue(note, value) {
    if (Number.isNaN(note)) {
        throw new Error('Error: Some key or value is not a number');
    }
    if (!Number.isInteger(value)) {
        throw new Error('Error: Some key is not an integer');
    }
    if (note < 0 || note > 5) {
        throw new Error('Error: Some key is out of range');
    }
    if (value < 0 || value > 100) {
        throw new Error('Error: Some value is out of range');
    }
}

function academicNotes(objectNotes) {
    validateInput(objectNotes);

    let accumulatedPercentage = 0;
    let accumulatedNote = 0;

    for (let note in objectNotes) {
        validateKeyValue(parseFloat(note), objectNotes[note]);

        accumulatedPercentage += objectNotes[note];
        accumulatedNote += (objectNotes[note] / 100) * parseFloat(note);
    }

    return { accumulatedPercentage, accumulatedNote };
}

module.exports = {
    academicNotes
};

console.log(academicNotes({ 2.9: 40, 3.1: '60x' }));
