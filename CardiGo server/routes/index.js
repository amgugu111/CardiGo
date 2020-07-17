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
  mydb.get('_all_docs',{ include_docs: true }, function(err, data) {
    var hofdata = [];
    var hof;
  if (err) console.log(err);
      else{
        for(let i = 0; i< data.total_rows;i++){
          hof = JSON.parse(data.rows[i].doc.result);
          hofdata.push ({
            employeeID: hof.Em_Id,
            class: hof.images[0].classifiers[0].classes[0].class,
            score: hof.images[0].classifiers[0].classes[0].score
          });
        }
        // console.log(hofdata);

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
