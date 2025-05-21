// NOTE: This library uses non-standard JS features (although widely supported).
// Specifically, it uses Function.name.

function any(v) {
    return true;
  }
  
  function isNumber(v) {
    return !Number.isNaN(v) && typeof v === 'number';
  }
  isNumber.expected = "number";
  
  //
  // ***YOUR CODE HERE***
  // IMPLEMENT THE FOLLOWING CONTRACTS
  //
  function isBoolean(v){
    return typeof v === 'boolean';
  }
  isBoolean.expected = "boolean";

  function isDefined(v){
    return typeof v !== 'undefined' && v !== null;
  }
  isDefined.expected = 'defined';

  function isString(v){
    return typeof v === 'string' || v instanceof String;
  }
  isString.expected = 'string';

  function isNegative(v){
    if (typeof v === 'number') {
        return v < 0;
    }
    return false;
  }
  isNegative.expected = 'negative number';
  
  function isPositive(v){
    if (typeof v === 'number') {
        return v > 0;
    }
    return false;
  }
  isPositive.expected = 'positive number';

  
  
  // Combinators:
  
  function and() {
    let args = Array.prototype.slice.call(arguments);
    let cont = function(v) {
      for (let i in args) {
        if (!args[i].call(this, v)) {
          return false;
        }
      }
      return true;
    }
    cont.expected = expect(args[0]);
    for (let i=1; i<args.length; i++) {
      cont.expected += " and " + expect(args[i]);
    }
    return cont;
  };
  
  //
  // ***YOUR CODE HERE***
  // IMPLEMENT THESE CONTRACT COMBINATORS
  //
  function or() {
    let args = Array.prototype.slice.call(arguments);
    let cont = function(v) {
        for (let i in args) {
            if (args[i].call(this, v)) {
                return true;
            }
        }
        return false;
    }
    cont.expected = expect(args[0]);
    for (let i=1; i<args.length; i++) {
        cont.expected += " or " + expect(args[i]);
    }
    return cont;
  };

  function not(arg) {
    let cont = function(v) {
        return !arg.call(this, v);
    }
    const expectedArg = expect(arg);
    cont.expected = "not " + expectedArg;
    return cont;
  };
  
  
  // Utility function that returns what a given contract expects.
  function expect(f) {
    // For any contract function f, return the "expected" property
    // if it is specified.  (This allows developers to specify what
    // the expected property should be in a more readable form.)
    if (f.expected) {
      return f.expected;
    }
    // If the function name is available, use that.
    if (f.name) {
      return f.name;
    }
    // In case an anonymous contract is specified.
    return "ANONYMOUS CONTRACT";
  }
  
  
  function contract (preList, post, f) {
    // ***YOUR CODE HERE***
    return new Proxy(f, {
      apply: function(target, thisArg, argumentsList) {
        // console.log(`prelist \n${preList}`);
        // console.log(`post \n${post}`);
        // console.log(`arguments ${argumentsList}`);
        for (let i = 0; i < preList.length; i++) {
          let pre = preList[i];
          let arg = argumentsList[i];
          // console.log(`pre ${pre}, pre expected ${pre.expected}, arg ${arg}`);
          //test arguments passed in, If any of the pre-conditions are not met, throw an exception blaming the caller.
          if (!pre.call(thisArg, arg)) {
            // console.log(`failed precondition: pre ${pre}, pre expected ${pre.expected}, arg ${arg}`);
            throw new Error(`Contract violation in position ${i}. Expected ${pre.expected} but received ${arg}. Blame -> Top-level code`);
          }
        }
        
        //If all of the preconditions passed, the function should be invoked and the result should be tested. 
        // console.log(`target ${target}, thisArg ${thisArg}, argumentsList ${argumentsList}`);
        let result = target.apply(thisArg, argumentsList);
        // console.log(`result: ${result}`);

        // If the post-condition is not met, throw an exception blaming the library.
        // (The pre-conditions and post-condition are specified using the contracts that you defined in part 1.
        if (!post.call(thisArg, result)) {
          // console.log("post condition failed");
          throw new Error(`Contract violation. Expected ${post.expected} but returned ${result}. Blame -> ${f.name}`);
        }
        return result;
      }
    });
  }
  
  
  module.exports = {
    contract: contract,
    any: any,
    isBoolean: isBoolean,
    isDefined: isDefined,
    isNumber: isNumber,
    isPositive: isPositive,
    isNegative: isNegative,
    isInteger: Number.isInteger,
    isString: isString,
    and: and,
    or: or,
    not: not,
  };
  
  