
function httpGet(theUrl) {
	console.log(theUrl)
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open( "GET", theUrl, false );
	xmlHttp.send( null );
	return xmlHttp.responseText;
}


const JSON_input = JSON.parse(httpGet('https://cors-anywhere.herokuapp.com/https://ancient-plateau-48847.herokuapp.com/'))
// const JSON_input = JSON.parse(temp)
var container = document.getElementById("container")

// console.log(container)
console.log(JSON_input)

let toAdd = ""
let count = 0
for (let elem_index in JSON_input) {
	// console.log("INDEX" + elem_index)
	let elem = JSON_input[elem_index]
	// console.log(elem)
	var url = elem.url // first
	let same = decodeURIComponent(url)
	var decode = window.atob(same)

	// console.log(elem2)
	// console.log(elem)
	toAdd += "<div class = 'half-row'>\
						<p class = 'top'>" + elem.line1 + "</p>\
						<p class = 'mid'>" + elem.line2 + "</p>\
						<p class = 'bot'>" + elem.line3 + "</p>\
						<img src = 'data:image/png;base64, " + same + "'>\
					</div>"
	// let base64Decoded = decodeURIComponent( escape( window.atob( elem.url ) ) )
	let row_counter = parseInt(elem_index) + 1
	console.log(row_counter)
	if (row_counter % 2 == 0 && row_counter !== 0) {
		console.log("create outside")
		// count = 0
		toAdd = "<div class = 'row'>" + toAdd + "</div>"
		container.innerHTML += toAdd
		// console.log(toAdd)
		toAdd = ""
	}


}

// 0: 1 half row, 



