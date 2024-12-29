const numericPad = [
  ["7","8","9"],
  ["4","5","6"],
  ["1","2","3"],
  [' ',"0",'A'],
];

const directionalPad = [
  [' ', '^', 'A'],
  ['<','v', '>'],
]

function assertEq(a,b) {
  // if (a !== b) throw new Error(`Assertion failed, ${a} !== ${b}`);
}

function findCoords(value, grid) {
  for (let y=0; y<grid.length; y++) {
    for (let x=0; x<grid[y].length; x++) {
      if (grid[y][x] === value) {
        return [x,y];
      }
    }
  }
  return undefined;
}

function path(initial, final, type) {
  if (type === 'numeric') {
    const dy = final[1] - initial[1];
    const dx = final[0] - initial[0];

    const vert = (dy < 0 ? '^' : 'v').repeat(Math.abs(dy));
    const horiz = (dx > 0 ? '>' : '<').repeat(Math.abs(dx));
    if (dy < 0 && dx < 0 && final[0] > 0) {
      return horiz + vert;
    }

    return vert + horiz;
  } else if (type === 'directional') {
    const dy = final[1] - initial[1];
    const dx = final[0] - initial[0];

    const vert = (dy < 0 ? '^' : 'v').repeat(Math.abs(dy));
    const horiz = (dx > 0 ? '>' : '<').repeat(Math.abs(dx));
    return dy < 0 ? horiz+vert : vert+horiz;
  } else {
    throw new Error("Not implemented");
  }
}

assertEq(path([2,2], [0,0], 'numeric'), '<<^^')

function solve(inputs) {
  const desired = inputs.split('').reverse();
  let prev = findCoords('A', numericPad);
  let result = '';
  while (desired.length) {
    const nextL = desired.pop();
    const next = findCoords(nextL, numericPad);

    result += path(prev, next, 'numeric') + 'A';

    prev = next;
  }
  return result;
}

function project(instructions) {
  const desired = instructions.split('').reverse();
  let prev = findCoords('A', directionalPad);
  let result = '';
  while (desired.length) {
    const nextD = desired.pop();
    const next = findCoords(nextD, directionalPad);

    result += path(prev, next, 'directional') + 'A';

    prev = next;
  }
  return result;
}

function complexity(instructions, code, ) {
  return [instructions.length, parseInt(code.replaceAll('A',''))];
}

const codes = [
  '029A',
  '980A',
  '179A',
  '456A',
  '379A',
]

const ans = codes.map(code => [code,project(project(solve(code)))])
  .map(([code, ins]) => complexity(ins,code));

console.log(ans);

function unproject(instructions, type) {
  const pad = type === 'directional' ? directionalPad : numericPad;
  
  const directions = instructions.split('').reverse();
  let [x,y] = findCoords('A', pad);
  let output = '';
  while (directions.length) {
    const next = directions.pop();
    if (next === '^') {
      y--;
    }
    if (next === 'v') {
      y++;
    }
    if (next === '<') {
      x--;
    }
    if (next === '>') {
      x++;
    }
    if (next === 'A') {
      output += pad[y][x];
    }

    if (pad[y]?.[x] === undefined) 
      throw new Error("OFF GRID");
    if (pad[y][x] === ' ') 
      throw new Error("ILLEGAL");
  }
  return output;
}

const ans2 = unproject(unproject(unproject('v<<A>>^AvA^Av<<A>>^AAv<A<A>>^AAvAA<^A>Av<A>^AA<A>Av<A<A>>^AAAvA<^A>A', 'directional'), 'directional'), 'numeric');

const comp = [
  '<v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A',
  'v<<A>>^AvA^Av<<A>>^AAv<A<A>>^AAvAA<^A>Av<A>^AA<A>Av<A<A>>^AAAvA<^A>A'
].map(c => unproject(c, 'directional')).map(c => c).join('\n');




console.log(comp);

console.log(project(project('<<^^A')))
console.log(project(project('^^<<A')))

console.log(unproject('<A','directional'));

// v<<A A >^A A>   A
// <A   A v<A A>>^ A

// v<A   <A   A >>^A  A   vA    <^A   >A A  vA ^A
// v<<A  >>^A A v<A   <A  >>^A    A   vA A <^A >A

