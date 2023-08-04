// read gcode file, loop over all lines to find smallest x and y values, then shift all lines to positive quadrant
// and write to new file

// imports
const fs = require('fs');
const readline = require('readline');

// variables
let xMin = 0;
let yMin = 0;
let xMax = 0;
let yMax = 0;


// read file
const rl = readline.createInterface({
    input: fs.createReadStream('input/gcode.nc'),
    crlfDelay: Infinity
});

// loop over lines
rl.on('line', (line) => {
    // console.log(`Line from file: ${line}`);
    // find min and max values
    if (line.startsWith('G01')) {
        const x = parseFloat(line.substring(line.indexOf('X') + 1, line.indexOf('Y')));
        const y = parseFloat(line.substring(line.indexOf('Y') + 1));
        if (x < xMin) {
            xMin = x;
        }
        if (y < yMin) {
            yMin = y;
        }
        if (x > xMax) {
            xMax = x;
        }
        if (y > yMax) {
            yMax = y;
        }
    }
}).on('close', () => {
    console.log(`xMin: ${xMin}, yMin: ${yMin}, xMax: ${xMax}, yMax: ${yMax}`);
    // shift all lines to positive quadrant
    const xShift = xMin * -1;
    const yShift = yMin * -1;
    console.log(`xShift: ${xShift}, yShift: ${yShift}`);
    // read file
    const rl2 = readline.createInterface({
        input: fs.createReadStream('input/gcode.nc'),
        crlfDelay: Infinity
    });
    // write file
    const ws = fs.createWriteStream('output/gcodeShifted.nc');
    // loop over lines
    rl2.on('line', (line) => {
        // console.log(`Line from file: ${line}`);
        // shift all lines
        if (line.startsWith('G01')) {
            const x = parseFloat(line.substring(line.indexOf('X') + 1, line.indexOf('Y')));
            const y = parseFloat(line.substring(line.indexOf('Y') + 1));
            const xNew = x + xShift;
            const yNew = y + yShift;
            const lineNew = line.replace(`X${x}`, `X${xNew}`).replace(`Y${y}`, `Y${yNew}`);
            ws.write(`${lineNew}\n`);
        } else {
            ws.write(`${line}\n`);
        }
    }).on('close', () => {
        console.log('Done');
    });
});