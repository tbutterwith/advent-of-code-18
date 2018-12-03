const fs = require('fs');

const input = fs.readFileSync('data/02.txt', 'utf8').split('\n');

const result = input.reduce((counts, val) => {
  const letters = {};
  Array.from(val).forEach(letter => {
    if (!letters[letter]) { letters[letter] = 0; }
    letters[letter] += 1;
  });

  const hasTwos = Object.keys(letters).filter(letter => letters[letter] == 2);
  const hasThrees = Object.keys(letters).filter(letter => letters[letter] == 3);

  if(hasTwos.length > 0) { counts.twos += 1 }
  if(hasThrees.length > 0) { counts.threes += 1 }

  return counts
}, { twos: 0, threes: 0 })

console.log(result.twos * result.threes);


try {
input.forEach((val, i) => {
  const currentString = Array.from(val);
  input.slice(i).forEach(nextStr => {
    const next = Array.from(nextStr);
    let counter = 0;
    let matchIndex;
    currentString.forEach((letter, j) => {
      if (letter != next[j]) { counter += 1; matchIndex = j;};
      if (counter == 1 && j == currentString.length - 1) {
        let result = currentString;
        result.splice(matchIndex, 1);
        throw new Error(`${result.join('')}`) } // early break out of the loops;
    });
  });
});
} catch (err) {
  console.log(err.message);
}