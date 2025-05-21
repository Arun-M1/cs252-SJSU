"use strict";

let Display = require('./graph.js');

let d = new Display(60, 30);

d.markPoints([1,3], [15,3], [7,9]);
d.render();

d.update(({val}) => !val);
d.render();

d.update(({i, j}) => i===j);
d.render();

d.clear();
d.markPoints(
  [4, 10],
  [5, 10],
  [6, 10],
);
d.render();

