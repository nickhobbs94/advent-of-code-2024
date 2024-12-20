#! /usr/bin/env node

const grid = 
`AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA`
.split('\n').map(e => e.split(''));

const width = grid[0].length;
const height = grid.length;

function insideShape(x,y,letter) {
  return x >= 0 && y >= 0 && x < width && y < height && grid[y][x] === letter;
}


function floodfill(start, inside, ) {

}

function hasDirectedBoundary(x,y,dirX,dirY) {
  const letter = grid[y][x];
  return !insideShape(x+dirX, y+dirY, letter);
}

const north = {};
const south = {};
const east = {};
const west = {};
const visited = {};

function fill(x,y) {
  const stack = [[x,y]];
  const letter = grid[y][x];
  while (stack.length) {
    [x,y] = stack.pop();
    visited[[x,y]] = true;
    if (!insideShape(x,y,letter)) continue;

    north[[x,y]] = hasDirectedBoundary(x,y,0,-1);
    south[[x,y]] = hasDirectedBoundary(x,y,0,+1);
    east[[x,y]] = hasDirectedBoundary(x,y,+1,0);
    west[[x,y]] = hasDirectedBoundary(x,y,-1,0);

    if (!visited[[x,y-1]]) stack.push([x,y-1]);
    if (!visited[[x,y+1]]) stack.push([x,y+1]);
    if (!visited[[x-1,y]]) stack.push([x-1,y]);
    if (!visited[[x+1,y]]) stack.push([x+1,y]);
  }
}



fill(2,1);

let walled = Object.entries(north)
  .filter(([_,value]) => value)
  .map(([k]) => k.match(/(\d+),(\d+)/))
  .map(r => r.slice(1).map(e => parseInt(e)));

let wallcount = 0;

const queue = [];
const [x,y] = walled.pop();
wallcount++;

while (queue.length) {
  const left = walled.find(([wx,wy]) => x-1 === wx && y === wy);
  const right = walled.find(([wx,wy]) => x+1 === wx && y === wy);

  if (left) {
    const [lx,ly] = left;
    walled = walled.filter(([ex,ey]) => ex !== lx || ey !== ly);
  }
}
console.log(left, right, x,y);
