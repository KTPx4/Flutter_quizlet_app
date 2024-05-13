const mongoose = require('mongoose')

let StudyCombineSchema = new mongoose.Schema({
    combineID: String,
    userID: String,
    studyCount: {
        type: Number,
        default: 0
    }

})


module.exports = mongoose.model('studycombine', StudyCombineSchema)