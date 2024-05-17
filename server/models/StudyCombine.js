const mongoose = require('mongoose')

let StudyCombineSchema = new mongoose.Schema({
    combineID: String,
    accountID: String,
    isMark: {
        type: Boolean,
        default: false
    },
    studyCount: {
        type: Number,
        default: 0
    }
    
})


module.exports = mongoose.model('studycombine', StudyCombineSchema)