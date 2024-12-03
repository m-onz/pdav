const fs = require('fs');
const { Midi } = require('@tonejs/midi');

// Function to extract MIDI numbers grouped by chords
async function extractChordsFromMidi(filePath) {
    // Read the MIDI file
    const data = fs.readFileSync(filePath);
    const midi = new Midi(data);
    const chords = []
    // Define a small time window to group notes into chords
    const chordTimeWindow = 0.1; // in seconds

    // Iterate over each track in the MIDI file
    midi.tracks.forEach(track => {
        let currentChord = [];
        let lastNoteTime = null;

        track.notes.forEach(note => {
            if (lastNoteTime === null || (note.time - lastNoteTime) <= chordTimeWindow) {
                // Add note to the current chord
                currentChord.push(note.midi);
            } else {
                // Output the current chord and start a new one
                if (currentChord.length > 0) {
                    //console.log('Chord:', currentChord);
                    chords.push(currentChord)
                }
                currentChord = [note.midi];
            }
            lastNoteTime = note.time;
        });

        // Output the last chord if any
        if (currentChord.length > 0) {
            //console.log('Chord:', currentChord);
	    chords.push(currentChord)
        }
    });
    //console.log(chords)
    var out = ``
    chords.forEach(function (chord) {
      out += (chord.toString().replace(/,/g, ' ') + ';\n')
    })
    console.log(out)
    fs.writeFileSync('output.txt', out)
}

// Example usage
extractChordsFromMidi('all.mid');
