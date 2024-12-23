out = a => (((a&0b111) ^ 0b101) ^ 0b110 ^ Math.floor(a/Math.pow(2,((a & 0b111) ^ 0b101))) & 0b111);
next = a => a >> 3;

const desired = [2,4,1,5,7,5,1,6,4,3,5,5,0,3,3,0];

function calc(desired, a) {
  console.log("calc", desired, a);
  if (!desired.length) return a;
  const nextOut = desired.pop();
  console.log("nextout", nextOut);
  
  let i;
  for (i=0; i<=0b111; i++) {
    const A = a*0b1000 + i;
    if (out(A) === nextOut) {
      console.log(A, '->', out(A), ':', nextOut, i);
      const nextA = calc(desired.slice(), A)
      if (nextA !== null) return nextA;
    }
  }

  if (i > 0b111) {
    return null;
  }
}

console.log(calc(desired.slice(), 0));
