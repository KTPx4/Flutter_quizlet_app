const mongoose = require('mongoose')

let StudyTopicSchema = new mongoose.Schema({
    topicID: String,
    accountID: String,    
    countCorrect: {
        type: Number,
        default: 0
    },
    time: {
        type:String,
        default: "00:00:00"
    },
    studyCount: {
        type: Number,
        default: 0
    }
    
})


module.exports = mongoose.model('studytopic', StudyTopicSchema)