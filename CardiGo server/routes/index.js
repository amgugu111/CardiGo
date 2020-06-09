var express = require('express');
var router = express.Router();
const http = require('http').createServer(express);

/* GET home page. */
router.get('/', function(req, res) {
  res.render('login', { title: 'Admin Login' });
});

//POST login data
router.post('/login', function(req, res) {
  if(req.body.username === "admin@xyz.com" && req.body.password === "admin"){
    res.redirect('https://deloitte.now.sh/');
  } else {
    res.redirect('/');
  }
    
});

//Socket Logic
const socketio = require('socket.io')(http)
var toneText =""

socketio.on("connection", (userSocket) => {
    userSocket.on("send_pulse", (data) => {
        userSocket.broadcast.emit("receive_pulse", data)
    })
    userSocket.on("send_feedback", (data) => {
        userSocket.broadcast.emit("receive_feedback", data)
        console.log(data)
    })
})

module.exports = router;
http.listen(process.env.PORT)
