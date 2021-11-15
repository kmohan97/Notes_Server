const express = require('express');
const mongoose = require('mongoose');
const schema = require('./schema.js');
const bodyParser12 = require('body-parser');
//location in module
const postRoute = require('./postRoutes/posts');

var app = express();

app.use(bodyParser12.json());

//middleware
app.use('/post',postRoute)

app.listen(3032, ()=>{
    console.log("Server is listening!")
})

mongoose.connect("mongodb://localhost/notesServer");

mongoose.connection.once("open", function (){
    console.log("Mongo DB connection Done--");
}).on('error',function (err){
   console.log("Mongo DB connection Error--"+err); 
})


app.get('/fetch', function (req, res) {
    console.log("in the fetch request")
    schema.find({}).then((items)=> {
        res.send(items);
        console.log(items);
    })
})


app.post('/update', function (req, res) {
    console.log("IN teh update bro")
    console.log(req.body.body);
    console.log(req.body.title);
    schema.findOneAndUpdate({
        _id: req.body.id
    },{
        title: req.body.title,
        body: req.body.body,
    },function (err){
        console.log("ERRROR")
        if(err){
            console.log("Error while updateing--"+err);
        }
        
    })
    res.send("UPDATED")
})