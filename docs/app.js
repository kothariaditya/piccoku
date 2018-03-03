function httpGet(theUrl) {
	console.log(theUrl)
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open( "GET", theUrl, false );
	xmlHttp.send( null );
	return xmlHttp.responseText;
}

const sampleInput = '[\
  {\
    "id": 3,\
    "user_name": "User1",\
    "url": "https://images.pexels.com/photos/34950/pexels-photo.jpg?h=350&dpr=2&auto=compress&cs=tinysrgb",\
    "created_at": "2018-03-03T20:20:18.262Z",\
    "updated_at": "2018-03-03T20:20:18.262Z",\
    "line1" : "ajl hi yum",\
    "line2" : "a chicken ate a bob",\
    "line3" : "bvob ate the chicken"\
  },\
  {\
    "id": 4,\
    "user_name": "User2",\
    "url": "https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?h=350&dpr=2&auto=compress&cs=tinysrgb",\
    "created_at": "2018-03-03T20:21:27.654Z",\
    "updated_at": "2018-03-03T20:21:27.654Z",\
    "line1" : "ajl hi yasdfum",\
    "line2" : "a chickeasdfasfsdaasdfn ate a bob",\
    "line3" : "bvob ateasdf the chicken"\
  },\
    {\
    "id": 4,\
    "user_name": "User2",\
    "url": "https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?h=350&dpr=2&auto=compress&cs=tinysrgb",\
    "created_at": "2018-03-03T20:21:27.654Z",\
    "updated_at": "2018-03-03T20:21:27.654Z",\
    "line1" : "ajlasdfasdfasfasdf hi yum",\
    "line2" : "a chickasdfasdfen ate a bob",\
    "line3" : "bvob atasdfasdfasdfe the chicken"\
  },\
    {\
    "id": 4,\
    "user_name": "User2",\
    "url": "https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?h=350&dpr=2&auto=compress&cs=tinysrgb",\
    "created_at": "2018-03-03T20:21:27.654Z",\
    "updated_at": "2018-03-03T20:21:27.654Z",\
    "line1" : "ajlasdfasdfasfasdf hi yum",\
    "line2" : "a chickasdfasdfen ate a bob",\
    "line3" : "bvob atasdfasdfasdfe the chicken"\
  }\
]'

const JSON_input = JSON.parse(sampleInput)
console.log(JSON_input)

let container = document.getElementById("container")
let parentElem;
for (let elem_index in JSON_input) {
	let elem = JSON_input[elem_index]
	let elem2 = JSON_input[elem_index + 1]
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
									<img src = " + elem.url + ">\
								</div>\
							</div>"
}







