var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  res.render('login', { title: 'Admin Login' });
});

//POST login data
router.post('/login', function(req, res) {
  if(req.body.username === "admin@deloitte.com" && req.body.password === "admin"){
    res.redirect('https://deloitte.now.sh/');
  } else {
    res.redirect('/');
  }
    
});

module.exports = router;
