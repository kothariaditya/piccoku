function httpGet(theUrl) {
	console.log(theUrl)
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open( "GET", theUrl, false );
	xmlHttp.send( null );
	return xmlHttp.responseText;
}


const JSON_input = JSON.parse(httpGet('https://cors-anywhere.herokuapp.com/https://ancient-plateau-48847.herokuapp.com/'))
let container = document.getElementById("container")

for (let elem_index in JSON_input) {
	let elem = JSON_input[elem_index]
	let elem2 = JSON_input[elem_index + 1]
	let base64Decoded = decodeURIComponent( escape( window.atob( elem.url ) ) )
	console.log(elem.url)
	console.log(base64Decoded)
	container.innerHTML += "<div class = 'row'>\
								<div class = 'half-row'>\
									<p class = 'top'>" + elem.line1 + "</p>\
									<p class = 'mid'>" + elem.line2 + "</p>\
									<p class = 'bot'>" + elem.line3 + "</p>\
									<img src = " + elem.url + ">\
								</div>\
								<div class = 'half-row'>\
									<p class = 'top'>" + elem.line1 + "</p>\
									<p class = 'mid'>" + elem.line2 + "</p>\
									<p class = 'bot'>" + elem.line3 + "</p>\
									<img src = 'data:image/jpg;base64," + base64Decoded + "'>\
								</div>\
							</div>"
}







