const maze = 
`###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############`
.split('\n').map(row => row.split(''));

const height = maze.length; const width = maze[0].length;

const validNext = ([x2,y2], phasing) => (x2 >= 0 && x2 < width && y2 >= 0 && y2 < height) && (maze[y2][x2] !== '#' || phasing);

const findCoords = letter => {
  const y = maze.findIndex(row => row.find(v => v === letter));
  const x = maze[y].findIndex(v => v === letter);
  return [x,y];
}

const start = findCoords('S');
const end = findCoords('E');

const printPos = (spots, symbol) => {
  symbol ??= 'X'
  const inspots = ([x,y]) => spots.find(e => e[0] === x && e[1] === y);
  for (let y=0; y<height; y++) {
    let s = '';
    for (let x=0; x<width; x++) {
      if (inspots([x,y])) {
        s += symbol;
      } else {
        s += maze[y][x];
      }
    }
    console.log(s);
  }
}


function solve() {
  const costs = {};
  let priorityPositions = [{pos: start, cost: 0, phased: null, remainingPhased: -1, exiting: false}];
  let positions = [];
  let savings = {};
  let baseCost;

  while (positions.length || priorityPositions.length) {

    const {pos, cost, phased, remainingPhased, exiting} = priorityPositions.length ? priorityPositions.pop() : positions.pop();
  
    const lookupKey = `${pos}|${phased}|${exiting}`;
    const [x,y] = pos;

    if (!costs[lookupKey] || costs[lookupKey] > cost) {
      costs[lookupKey] = cost;
    } else {
      continue;
    }

    const pushNext = (vec, newcost, phased, delta) => {
      const original = vec;
      const inWall = maze[vec[1]][vec[0]] === '#';
      vec = [vec[0] + delta[0], vec[1] + delta[1]]
      if (!phased) {
        if (validNext(vec, false)) {
          priorityPositions.push({pos: vec, cost: newcost, phased: null, remainingPhased, exiting: false})
        } else if (validNext(vec, true)) {
          positions.push({pos: vec, cost: newcost, phased: original, remainingPhased: 20, exiting: false});
        }
      } else if (validNext(vec, false) && remainingPhased >= 0) {
        positions.push({pos: vec, cost: newcost, phased, remainingPhased: remainingPhased-1, exiting: inWall});
      } else if (validNext(vec, true) && remainingPhased >= 0) {
        positions.push({pos: vec, cost: newcost, phased, remainingPhased: remainingPhased-1, exiting: false});
      } else if (validNext(vec, false) && remainingPhased == 0) {
        // positions.push({pos: vec, cost: newcost, phased, remainingPhased: -1});
      }
    }

    pushNext([x,y], cost+1, phased, [1,0]);
    pushNext([x,y], cost+1, phased, [-1,0]);
    pushNext([x,y], cost+1, phased, [0,1]);
    pushNext([x,y], cost+1, phased, [0,-1]);
  
    // FOUND IT!
    if (x === end[0] && y === end[1]) {
      if (!phased) {
        baseCost ??= cost;
        baseCost = Math.min(baseCost, cost);
      }

      if (phased) {
        //throw new Error("OH NO");
      }
    }
  }
  return {costs};
}

const {costs} = solve();



const results = Object.entries(costs).map(([k,v]) => {
  const [end,start,exiting] = k.split('|');
  return {
    end: end.split(',').map(e => parseInt(e)),
    start: start !== 'null' ? start.split(',').map(e => parseInt(e)) : null,
    exiting: exiting === 'true',
    cost: v,
  };
});

const baseCosts = results.filter(e => e.start === null);
const answer = results.filter(e => e.start !== null && e.exiting === true)
  .filter(e => {
    const [x1,y1] = e.start;
    const [x2,y2] = e.end;
    return x1 !== x2 || y1 !== y2;
  })
  .map(e => {
    const [x1,y1] = e.start;
    const [x2,y2] = e.end;

    const base = baseCosts.find(b => b.end[0] === x2 && b.end[1] === y2).cost;
    return {...e, delta: base - e.cost};
  })
  .filter(e => e.delta === 72)
  

console.log(answer);
console.log(answer.length);