var foldl = function (f, acc, array) {
    if (array.length === 0) {
        return acc;
    }
    var new_acc = f(acc, array[0]);
    return foldl(f, new_acc, array.slice(1));
}

console.log(foldl(function(x,y){return x+y}, 0, [1,2,3]));

var foldr = function (f, z, array) {
    if (array.length === 0) {
        return z;
    }
    var new_z = f(array.at(-1), z);
    return foldr(f, new_z, array.slice(0, -1));
}

console.log(foldr(function(x,y){return x/y}, 1, [2,4,8]));

var map = function (f, array) {
    //returning a modified list
    if (array.length === 0) {
        return [];
    }
    var head = f(array[0]);
    //console.log("head" + head);
    var tail = map(f, array.slice(1));
    //console.log("tail" + tail);

    return [head].concat(tail);
}

console.log(map(function(x){return x+x}, [1,2,3,5,7,9,11,13]));


// Write a curry function as we discussed in class.
// Create a `double` method using the curry function
// and the following `mult` function.
function mult(x,y) {
  return x * y;
}

Function.prototype.curry = function() {
    var slice = Array.prototype.slice,
        args = slice.apply(arguments),
        that = this;
    return function () {
      return that.apply(null, args.concat(slice.apply(arguments)));
    };
  };

// function double(x) {
//     return mult(x, 2);
// }
// console.log(double(4));

var double = mult.curry(2);
console.log(double(3));

function Student(fName, lName, id) {
    this.fName = fName;
    this.lName = lName;
    this.id = id;
    this.display = function() {
        console.log("first name:" + this.fName + ", last name:" + this.lName + ", student id:" + this.id);
    } 
}

var student_arr = [
    new Student("a", "b", "0"),
    new Student("c", "d", "1"),
    new Student("e", "f", "2"),
]

var i;
for (i = 0; i < student_arr.length; i++) {
    student_arr[i].display();
}

student_arr[0].graduated = true;

console.log(student_arr[0]);

Student.prototype.display = function() {
    console.log("first name:" + this.fName + ", last name:" + this.lName + ", student id:" + this.id);
}

charlie = 5;
var student_without_constructor = {
    fName: "Arun",
    lName: "Murugan",
    id: "12345678",
    charlie: 7,
    __proto__: Student.prototype,
    someFunc: function() {
        console.log(this.fName);
        let funcTwo = () => {
            console.log(this.charlie);
            // console.log(this.lName);
        }
        funcTwo();
    }
}

student_without_constructor.display();
student_without_constructor.someFunc();