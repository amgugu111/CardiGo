var express = require('express');
var router = express.Router();
const feedbackSchema = require('../models/feedback.js');
var Cloudant = require('@cloudant/cloudant');

//cloudant database
var cloudant = Cloudant({ account: '55db52cb-dfa3-488a-b55a-d388a3ea1376-bluemix', password: 'f685ba8c7f9890ed3b96d35595f4bfa272a364ce877ebade6d278462d8433cfa' });
var mydb = cloudant.db.use('nodered');




/* GET home page. */
router.get('/', function(req, res) {
  res.render('login', { title: 'Admin Login' });
});

/* GET science page. */
router.get('/science', function(req, res) {
  res.render('science');
});

/* GET dashboard page. */
router.get('/dashboard', function(req, res) {
  mydb.get('score1', function(err, data) {
    if (err) console.log(err);
    else{
      console.log(typeof(data))
    // console.log(data.result);
    var hof = JSON.parse(data.result);
    // console.log(hof.images[0].classifiers[0].classes[0]);
    var hofdata = {
      employeeID: hof.Em_Id,
      class: hof.images[0].classifiers[0].classes[0].class,
      score: hof.images[0].classifiers[0].classes[0].score
    }
    console.log(hofdata);
    console.log(hofdata.employeeID);
    feedbackSchema.find({},(err, data) => {
      if (err) console.log(err);
      else{
      res.render('dashboard', { "feedback" : data, "hofdata" : hofdata });
    }

});
    }
    
}); 
});

//POST login data
router.post('/login', function(req, res) {
  if(req.body.username === "admin@deloitte.com" && req.body.password === "admin"){
      res.redirect('/dashboard');
    } else {
    res.redirect('/');
  }
    
});

/* GET dashboard page. */
// router.get('/admin', function(req, res) {
//   res.render('dashboard', { title: 'Admin dashboard' });
// });

/* GET  page. */
// router.get('/dashboard/:str', function(req, res) {
//   res.send(req.params.str);
  
// });



module.exports = router;
