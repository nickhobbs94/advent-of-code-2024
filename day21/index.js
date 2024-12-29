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
    
    return [...(new Set([horiz + vert+'A', vert + horiz+'A']))];

  } else if (type === 'directional') {
    const dy = final[1] - initial[1];
    const dx = final[0] - initial[0];

    const vert = (dy < 0 ? '^' : 'v').repeat(Math.abs(dy));
    const horiz = (dx > 0 ? '>' : '<').repeat(Math.abs(dx));
    return [...(new Set([horiz+vert+'A' , vert+horiz+'A']))];
  } else {
    throw new Error("Not implemented");
  }
}


function project(instructions) {
  console.log('project', instructions, typeof instructions);
  const desired = instructions.split('').reverse();
  let prev = findCoords('A', directionalPad);
  let results = [''];
  while (desired.length) {
    const nextD = desired.pop();
    const next = findCoords(nextD, directionalPad);

    const paths = path(prev, next, 'directional');

    results = paths.flatMap(path => results.map(a => a + path));

    prev = next;
  }
  return results;
}

function unproject(instructions, type, from) {
  const pad = type === 'directional' ? directionalPad : numericPad;
  from ??= findCoords('A', pad);
  
  const directions = instructions.split('').reverse();
  let [x,y] = from;
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
      return null;
    if (pad[y][x] === ' ') 
      return null;
  }
  return output;
}

function shortest(paths, from) {
  let shortest = null;
  console.log('paths', paths)
  for (let path of paths) {
    console.log('path', path);
    const robot1 = unproject(path, 'directional');
    if (robot1 === null) continue;
    console.log('r1', robot1);
    const robot2 = unproject(robot1, 'directional');
    if (robot2 === null) continue;
    console.log('r2', robot2);
    const robot3 = unproject(robot2, 'numeric', from);
    if (robot3 === null) continue;
    console.log('r3', robot3);

    shortest ??= path;
    if (shortest.length > path.length) {
      shortest = path;
    }
  }
  if (shortest === null) {
    console.log(paths);
    throw new Error("WHAT");
  }
  return shortest;
}

function solve(inputs) {
  const desired = inputs.split('').reverse();
  let prev = findCoords('A', numericPad);
  let result = '';
  while (desired.length) {
    const nextL = desired.pop();
    const next = findCoords(nextL, numericPad);
    console.log('solving', nextL);

    let paths = path(prev, next, 'numeric');

    console.log('paths 0', paths);
    paths = paths.flatMap(path => project(path));
    console.log('paths 1', paths);
    paths = paths.flatMap(path => project(path));
    console.log('paths 2', paths);

    result += shortest(paths, prev);

    prev = next;
  }
  return result;
}


function complexity(instructions, code, ) {
  return [instructions.length, parseInt(code.replaceAll('A',''))];
}

const codes = [
  '129A',
  '176A',
  '985A',
  '170A',
  '528A',
]

const ans = codes.map(code => [code,solve(code)])
  .map(([code, ins]) => complexity(ins,code))
  .map(([a,b]) => a*b)
  .reduce((acc,e) => acc + e, 0);

console.log(ans);

