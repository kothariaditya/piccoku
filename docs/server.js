const express = require('express')
const hbs = require('hbs')
const path = require('path')

var app = express();

app.set('view engine', 'hbs');
app.use(express.static(__dirname));
hbs.registerPartials(path.join(__dirname, "views"));

app.get('/', function(req, res) {
  res.render('index.hbs', {
    body: [{
      line1: "bob ate some chicken",
      line2: "joe at some chicken",
      line3: "the chicken ate the chicken",
      src: "img/dog.png"
    },
    {
      line1: "bob ate some chicken",
      line2: "joe at some chicken",
      line3: "the chicken ate the chicken",
      src: "img/dog.png"
    },
    {
      line1: "bob ate some chicken",
      line2: "joe at some chicken",
      line3: "the chicken ate the chicken",
      src: "img/dog.png"
    },
    {
      line1: "bob ate some chicken",
      line2: "joe at some chicken",
      line3: "the chicken ate the chicken",
      src: "img/dog.png"
    }]
  })
});

app.get('/profile', function(req, res) {
  res.render('profile.hbs', {
    name: "bob",
    haikyus: [{
      line1: "bob ate some chicken",
      line2: "joe at some chicken",
      line3: "the chicken ate the chicken",
      src: "img/dog.png"
    },
    {
      line1: "chicken ate some bob",
      line2: "bob ate some chicken",
      line3: "the bob ate the chicken",
      src: "img/dog.png"
    }]
  })
});

app.listen(3000, () => {
  console.log("Server is up on port 3000");
})