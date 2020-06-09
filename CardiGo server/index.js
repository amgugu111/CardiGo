const http = require('http').createServer(app)
const express = require('express');
const app = express();
const path = require('path');
const router = express.Router();

 
router.get('/',function(req,res){
    res.sendFile(path.join(__dirname+'/login.html'));
    //__dirname : It will resolve to your project folder.
  });

//POST login data
router.post('/login', function(req, res) {
    if(req.body.username === "admin@xyz.com" && req.body.password === "admin"){
      res.redirect('https://deloitte.now.sh/');
    } else {
      res.redirect('/');
    }
      
  });

//IBM tone analyzer
const ToneAnalyzerV3 = require('ibm-watson/tone-analyzer/v3')
const { IamAuthenticator } = require('ibm-watson/auth')
const toneAnalyzer = new ToneAnalyzerV3({
    version: '2017-09-21',
    authenticator: new IamAuthenticator({
      apikey: 'bwr2M3a7H8LEf-ooPotXv_tHKySMbP1FhBn6ohmv6bQv',
    }),
    url: 'https://api.eu-gb.tone-analyzer.watson.cloud.ibm.com/instances/6b05ee63-5752-49ed-9a60-1cb1bf674f04',
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


http.listen(process.env.PORT)