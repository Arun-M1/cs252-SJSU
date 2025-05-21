var globalName:string = "Monty";

class Rabbit {
    name: string;
    constructor(name: string) {
        this.name = name;
    }
}

var r = new Rabbit("Python");

console.log(r.name);  // ERROR!!!
console.log(globalName);    // Prints "Python"


