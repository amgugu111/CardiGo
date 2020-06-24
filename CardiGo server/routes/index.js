var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  res.render('login', { title: 'Admin Login' });
});

//POST login data
router.post('/login', function(req, res) {
  if(req.body.username === "admin@deloitte.com" && req.body.password === "admin"){
    res.render('dashboard', { title: 'Admin dashboard' });
  } else {
    res.redirect('/');
  }
    
});

/* GET dashboard page. */
// router.get('/admin', function(req, res) {
//   res.render('dashboard', { title: 'Admin dashboard' });
// });

/* GET  page. */
router.get('/dashboard/:str', function(req, res) {
  res.send(req.params.str);
  
});

module.exports = router;
