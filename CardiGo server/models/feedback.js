var mongoose = require('mongoose');
var Schema = mongoose.Schema;

  var feedbackSchema = new Schema({
    id:{type:String},
    score: {type: [String]},
    toneId:  {type: [String]}
  });

  var feedback = mongoose.model('feedback',feedbackSchema);
  module.exports = feedback;