const fs = require('fs');

const input = fs.readFileSync('data/01.txt', 'utf8').split('\n');

const frequencies = []
let result;
let work = 0;
while (result == undefined) {

  work = input.reduce((acc, val) => {
    const [operator, ...numArr] = val;
    const num = parseInt(numArr.join(''), 10);
    let freq;
    if (operator == '-') { freq = acc - num; }
    else { freq =  acc + num; }
    if (frequencies.includes(freq) && result == undefined) { result = freq }
    frequencies.push(freq);
    return freq
  }, work)

}

console.log(result);