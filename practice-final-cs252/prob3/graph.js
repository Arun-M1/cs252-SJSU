"use strict";

// Creates a new text display area.
function Display(width, height) {
  this.width = width;
  this.height = height;
  this.clear();
}

// Unsets all points of the graph.
Display.prototype.clear = function() {
  this.graph = [];
  for (let i=0; i<this.height; i++) {
    let row = [];
    row.length = this.width;
    this.graph.push(row);
  }
}

// Sets the specified points of the graph.
Display.prototype.markPoints = function(...args) {
  for (let [x,y] of args) {
    this.graph[y][x] = true;
  }
}

// Sets points randomly according to the specified probability.
Display.prototype.randomFill = function(prob=0.5) {
  for (let i=0; i<this.height; i++) {
    for (let j=0; j<this.width; j++) {
      if (Math.random() < prob) {
        this.graph[i][j] = true;
      } else {
        this.graph[i][j] = false;
      }
    }
  }
}

// Print out the graph.
Display.prototype.render = function() {
  console.log("GRAPH:");
  for (let i=this.height-1; i>=0; i--) {
    let s = "";
    for (let j=0; j<this.width; j++) {
      if (this.graph[i][j] === true) s += 'X';
      else s += '.';
    }
    console.log(s);
  }
}


// Update the graph according to the specified callback function.
Display.prototype.update = function(f) {
  //
  // ***YOUR CODE HERE***
  //
  let graphClone = JSON.parse(JSON.stringify(this.graph));
  // Update a graph, using the callback function on every cell of
  // the graph.  You should pass an object to the callback function
  // with the following properties:
  for(let i = this.height - 1; i >= 0; i--) {
    for(let j = 0; j < this.width; j++) {
      //  graph: the previous UNMODIFIED graph.
      //     (Be sure to do a deep clone of this graph.)
      //  val: the current true/false value of the cell
      //  i: the row number of the cell
      //  j: the column number of the cell
      let val = this.graph[i][j];
      let newVal = f({val: val, i: i, j: j, graph: graphClone});

      // The callback function will return either true or false,
      // which should be set as the new value of the cell.

      this.graph[i][j] = newVal;
    }
  }
  //
  //
}

// Update the graph every 100 milliseconds
//this. script scope
Display.prototype.run = function(f) {
  //
  // ***YOUR CODE HERE***
  //
  // Every 100 milliseconds, this method should:
  //this. display scope
  setInterval(() => {
    // 1) Clear the screen.  (You can do this with console.clear()).
    console.clear();
  // 2) Update the graph with the callback function.  (You can use
  //     the update method of this object.)
    this.update(f);
  // 3) Display the graph (using the render method of this object).
    this.render();
  // You may use either setTimeout or setInterval, at your choice.
  }, 100);
}

module.exports = Display;

