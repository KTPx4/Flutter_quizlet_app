const mongoose = require('mongoose')

let CombineWordSchema = new mongoose.Schema({    
    topicID: String,
    desc: {
        type: String,
        default: ""
    },
    img: {
        type: String,
        default: ""
    },
    mean1: {
        title: String,
        lang: String
    },
    mean2: {
        title: String,
        lang: String
    },
})

module.exports = mongoose.model('combineword', CombineWordSchema)