"use strict";

// Matches paterns like '3-10'
const RANGE_PAT = /^(\d+)-(\d+)$/;

// Matches negative index values
const FROM_END_PAT = /^-(\d+)$/;

const NUM_PAT = /^-?\d+$/;

function SmartArray(...args) {
  return new Proxy(args, {
    get: function(target, prop) {
      if (prop.match(RANGE_PAT)) {
        // Return a subarray of the elements in the specified range,
        // INCLUDING the specified end index.
        let start = parseInt(prop.replace(RANGE_PAT, "$1"));
        let end = parseInt(prop.replace(RANGE_PAT, "$2")) + 1;
        //console.log(start, end);
        return target.slice(start, end);
      } else if (prop.match(FROM_END_PAT)) {
        //
        // ***YOUR CODE HERE***
        //
        // Return the element at the specified position, counting
        // back from target.length.  So "-1" will refer to the last
        // element in the array.
        let negIdx = -parseInt(prop.replace(FROM_END_PAT, "$1"));
        let newIdx = target.length + negIdx;
        // console.log(negIdx, newIdx);
        //
        // If the resulting index position is negative,
        // raise an exception.
        if (newIdx < 0) {
            throw new Error("index out of range");
        }
        return target.at(newIdx);
      } else {
        // Do the usual array thing -- get the value at the specified index.
        return Reflect.get(...arguments);
      }
    },
    set: function(target, prop, newVal) {
      //
      // ***YOUR CODE HERE***
      //
      // For smart arrays, we only allow updates to numerical fields.
      // Throw an exception for a 'prop' that is not a valid integer.
      //console.log(target, prop, newVal, typeof(prop));
      let idx = Number(prop);
      if (isNaN(idx)) {
        throw new Error("not a number");
      }

      if (idx < 0) {
        idx = target.length + idx;
      }

      if (!(idx >= 0 && idx < target.length)) {
        throw new Error("index out of bounds");
      }
    
      target[idx] = newVal;
      return true;
      // If prop is zero or positive, update the array position normally.
      //
      // If negative, update the position counting from the end of the array.
      // However, raise an exception if the resulting index is still negative.
    },
    deleteProperty: function(target, prop) {
        let idx = Number(prop);
        if (idx < 0) {
            idx = target.length + idx;
        }

        if (!(idx >= 0 && idx < target.length)) {
            throw new Error("index out of bounds");
        }
        // target[idx] = undefined;
        return delete target[idx];
    },
  });
}

let arr = SmartArray('a', 'b', 'c', 'd', 'e', 'f');

console.log(arr[0]); // a
console.log(arr[4]); // e
console.log(arr['hello']); // undefined

console.log(arr['2-4']); // [c,d,E]
console.log(arr['3-5']); // [d,E,f]

console.log(arr[-1]); // f
console.log(arr[-3]); // d

try {
  console.log(arr[-99]);
} catch (e) {
  console.log("Exception correctly thrown.");
}

arr[1] = 'B';
console.log(arr[1]); // B

arr[-2] = 'E';
console.log(arr[4]); // E

try {
  arr['2-4'] = 'hello';
} catch (e) {
  console.log("Exception correctly thrown.");
}

try {
  arr[3*"hello"] = 'hello';
} catch (e) {
  console.log("Exception correctly thrown.");
}

console.log("Deleted " + arr[0] + ", " + delete arr[0]); //true

try {
    delete(arr[3*"hello"]);
} catch (e) {
    console.log("Exception correctly thrown.");
}

console.log(arr);
