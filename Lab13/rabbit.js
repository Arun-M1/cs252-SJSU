var globalName = "Monty";
var Rabbit = /** @class */ (function () {
    function Rabbit(name) {
        this.name = name;
    }
    return Rabbit;
}());
var r = new Rabbit("Python");
console.log(r.name); // ERROR!!!
console.log(globalName); // Prints "Python"
