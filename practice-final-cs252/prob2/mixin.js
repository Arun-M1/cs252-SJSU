"use strict";

function addMixin(o, mixin) {
  //
  // ***YOUR CODE HERE***
  return new Proxy(o, {
      //1) If the object already has a property, the object's property is returned.

      // 2) If the object does not have the property, it returns the property from the mixin object.

      // 3) If the property is "__original", it returns the original object "o".  (This design provides a way to "unmix" a mixin.)

      // 4) If none of the other cases hold, undefined should be returned as the result.
    get: function(target, prop) {
      if (prop in target) {
        return target[prop];
      } 
      if (prop in mixin) {
        return mixin[prop];
      }
      if (prop === "__original") {
        return o;
      }

      return undefined;
    }, 
  });
  //
}

// A sample mixin.
let PlayableMixin = {
  // Plays a system bell 3 times
  play: function() {
    console.log("\u0007");
    console.log("\u0007");
    console.log("\u0007");
  },
  duration: 100,
};

function Song(name, performer, duration) {
  this.name = name;
  this.performer = performer;
  this.duration = duration;
}
Song.prototype = addMixin(Song.prototype, PlayableMixin);

Song.prototype.display = function() {
  console.log(`Now playing "${this.name}", by ${this.performer}. (${this.duration})`);
}

let s = new Song("Gun Street Girl", "Tom Waits", "4:17");
s.display();
s.play();

console.log(s.duration);

s = s.__original;

console.log(s.play);

