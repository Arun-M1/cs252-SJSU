function makeAdder(x) {
    return function(y) {
        return x + y;
    }
}

var addOne = makeAdder(1);
console.log(addOne(10));

function makeListOfAdders(nums) {
    var adders = [];
    // for(let i = 0; i < nums.length; i++) {
    //     adders.push(makeAdder(nums[i]));
    // }
    var i, arr = [];
    for (i=0; i<lst.length; i++) {
        (function() {
         var n = lst[i];
         arr[i] = function(x) {
            return x + n;
         }
        })();
    }   

    return adders;
}

a = makeListOfAdders([1,5]);
a[0](42); //43
a[1](42); //47
console.log(a[0](42));
console.log(a[1](42));