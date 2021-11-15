var express = require('express');

var schema = require('../schema')

var router = express.Router();

router.post('/add', function (req, res){
    console.log("PIN I M CALLED")
    var note = new schema({
        title: req.body.title,
        body: req.body.body,
    })
    note.save().then(function(){
        if(note.isNew == false){
            console.log("SAVED!!!");
            res.send("SAVED");
            res.sendStatus(200);
        }else{
            console.log("ERROR");
        }
    })    
})


// router.post('/update', function (req, res) {
//     console.log("IN teh update bro")

//     schema.findOneAndUpdate({
//         _id: req.body.id
//     },{
//         title: req.body.title,
//         body: req.body.body,
//     },function (err){
//         if(err){
//             console.log("Error while updateing--"+err);
//         }
        
//     })
//     res.send("UPDATED")
// })

router.post('/delete', function (req, res){
    // console.log(req.body)
    console.log("POIUHJKL:")
    // console.log(req.body.id)
    console.log(req.body.id)
    schema.findOneAndDelete({
        _id: req.body.id
    }, (err) => {
        console.log("Error in deleting"+err);
    })
    res.send("DELETED It bro " +req.body.id)
})

module.exports = router;