// Add color blobs in-front of filename in an lcov index.html. Each blob,
// corresponds to the color status of the function, line, region coverage column.
// Makes it easier to see the cover overview on mobile.

function setColorBlobs(row) {
  let blobGlyph = "⬩";
  let grey = `<span class="blob grey">${blobGlyph}</span>`;
  let green = `<span class="blob green">${blobGlyph}</span>`;
  let red = `<span class="blob red">${blobGlyph}</span>`;
  let classes = {
    "column-entry-green": green,
    "column-entry-yellow": grey,
    "column-entry-red": red,
  };

  let td = row.cells.item(0);
  var blobs = [1,2,3].map( (i) => classes[row.cells.item(i).classList[0]] );

  if (row != document.querySelector("tr:last-child")) {
    td.innerHTML = `<nobr>${blobs.join("")}${td.innerHTML}</nobr>`;
  }
}

function removeBranchColumn(row) {
  var last = row.querySelector('td:last-child')
  row.removeChild(last)
}

function ready() {
  let rows = document.querySelectorAll("tr");
  rows.forEach( r => {
    setColorBlobs(r);
    removeBranchColumn(r);
  })
}

// inject it into the index.html for a coverage folder.
// <script src="/js/addBlobs.js"/>
document.addEventListener("DOMContentLoaded", function(event) {
  console.log("DOMContentLoaded");
  console.log(event);
  ready();
});
