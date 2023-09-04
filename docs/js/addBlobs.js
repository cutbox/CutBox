// Add color blobs in-front of filename in an lcov index.html. Each blob,
// corresponds to the color status of the function, line, region coverage column.
// Makes it easier to see the cover overview on mobile.

function setColorBlobs(row) {
  let blobGlyph = '⬩'
  let grey = `<span class="blob grey">${blobGlyph}</span>`
  let green = `<span class="blob green">${blobGlyph}</span>`
  let red = `<span class="blob red">${blobGlyph}</span>`
  let classes = {
    "column-entry-green": green,
    "column-entry-yellow": grey,
    "column-entry-red": red
  }

  let td = row.cells.item(0)
  var blobs = [
    1,
    2,
    3
  ].map( (i) => classes[row.cells.item(i).classList[0]] )

  td.innerHTML = `<nobr>${blobs.join("")}${td.innerHTML}</nobr>`
}

function ready() {
  let t = document.querySelector('table')
  for(var i = 1; i < t.rows.length -1; i++) {
    setColorBlobs(t.rows.item(i))
  }
  console.log("Doc ready...")
}

// inject it into the index.html for a coverage folder.
// <script src="/js/addBlobs.js"/>

document.addEventListener("DOMContentLoaded", function(event) {
  console.log("DOMContentLoaded")
  console.log(event)
  ready()
});
