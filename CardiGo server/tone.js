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
          // console.log(toneAnalysis.result.document_tone.tones)
          // console.log(JSON.stringify(toneAnalysis.result, null, 2));
          var str="";
          console.log(toneAnalysis.result.document_tone.tones);
          toneFeedback = toneAnalysis.result.document_tone.tones;
          for(i = 0; i<toneFeedback.length;i++){
            str+=toneFeedback[i].score+"-"+toneFeedback[i].tone_id+"-";
          }
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




