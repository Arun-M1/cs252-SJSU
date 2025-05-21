"use strict";

let Display = require('./graph.js');

let d = new Display(60, 30);
d.randomFill(0.20);

let life = ({val, i, j, graph}) => {

  let countLive = (i,j) => {
    let live = 0;
    if (j>0 && graph[i][j-1]) live++;
    if (graph[i][j]) live++;
    if (graph[i][j+1]) live++;
    return live;
  }

  let liveNeighbors = 0;
  if (i>0) {
    liveNeighbors += countLive(i-1,j);
  }
  liveNeighbors += countLive(i,j);
  if (graph[i+1] !== undefined) {
    liveNeighbors += countLive(i+1,j);
  }

  if (val) {
    liveNeighbors--; // Removing the cell itself from the count
    if (liveNeighbors < 2) return false;
    else if (liveNeighbors > 3) return false;
    else return true;
  } else {
    if (liveNeighbors === 3) return true;
    else return false;
  }
};

d.run(life);

