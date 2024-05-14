const mongoose = require('mongoose')

let StudyCombineSchema = new mongoose.Schema({
    combineID: String,
    accountID: String,
    isMark: Boolean,
    countCorrect: {
        type: Number,
        default: 0
    },
    studyCount: {
        type: Number,
        default: 0
    }
    
})


module.exports = mongoose.model('studycombine', StudyCombineSchema)