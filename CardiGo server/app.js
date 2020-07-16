var express = require('express');
var path = require('path');
var favicon = require('static-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var routes = require('./routes/index');
var users = require('./routes/users');
var mongoose = require('mongoose');
const feedbackSchema = require('./models/feedback.js');

//tonejs code
const ToneAnalyzerV3 = require('ibm-watson/tone-analyzer/v3');
const { IamAuthenticator } = require('ibm-watson/auth');
const io = require('socket.io-client');
var request = require('ajax-request');

var toneText = "";
var toneFeedback;
const socket = io('https://cardigo.eu-gb.cf.appdomain.cloud');
      socket.on('connect',  () => {
        //receive feedback
      socket.on('receive_feedback', (data) => {
      console.log(data.feedbackSent.question_3)
      toneFeedback = getFeedback(data)
      });
    });


const toneAnalyzer = new ToneAnalyzerV3({
    version: '2017-09-21',
    authenticator: new IamAuthenticator({
      apikey: 'bwr2M3a7H8LEf-ooPotXv_tHKySMbP1FhBn6ohmv6bQv',
    }),
    url: 'https://api.eu-gb.tone-analyzer.watson.cloud.ibm.com/instances/6b05ee63-5752-49ed-9a60-1cb1bf674f04',
  });

  function getFeedback(data) {
    console.log('inside function')
    toneText = data.feedbackSent.question_3.toString();
    const toneParams = {
        toneInput: { 'text': toneText },
        contentType: 'application/json',
        sentences: 'false'
      };
      
      toneAnalyzer.tone(toneParams)
        .then(toneAnalysis => {
          var str="";
          var score = [];
          var toneId = [];
          console.log(toneAnalysis.result.document_tone.tones);
          toneFeedback = toneAnalysis.result.document_tone.tones;
          for(i = 0; i<toneFeedback.length;i++){
            score.push(toneFeedback[i].score);
            toneId.push(toneFeedback[i].tone_id);

            str+=toneFeedback[i].score+"-"+toneFeedback[i].tone_id+"-";
          }
          let newFeedback = new feedbackSchema({id:data.feedbackSent.Id,score:score,toneId:toneId});
            newFeedback.save();
          console.log(str);
          request({
            url: 'http://localhost:3000/dashboard/'+str,
            method: 'GET'
          }, function(err, res, body) {
            console.log("ajax success");
          });
        })
        .catch(err => {
          console.log('error:', err);
        });
  }
//
var app = express();
const http = require('http').createServer(app);

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(favicon());
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({extended: true}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
app.use('/users', users);

//mongodb logic
mongoose.connect("mongodb+srv://sarthak-rout:Sarthak97@baisakhi-exsyw.mongodb.net/cardigo?retryWrites=true&w=majority",{reconnectTries:Number.MAX_VALUE,poolSize:10}).then(()=>{console.log("connected")}
,err=>{console.log(err)});

/// catch 404 and forwarding to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
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

/// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});


module.exports = app;
http.listen(process.env.PORT);
