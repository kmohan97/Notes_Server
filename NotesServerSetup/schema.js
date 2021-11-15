var mongoose = require('mongoose');
var schema = mongoose.Schema;

var type = new schema({

    body: String,
    title: String
})

var model = mongoose.model("note",type);
module.exports = model;