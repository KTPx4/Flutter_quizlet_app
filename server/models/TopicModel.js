const mongoose = require('mongoose')
const moment = require('moment-timezone');
const dateVietnam = moment.tz(Date.now(), "Asia/Ho_Chi_Minh");
let TopicSchema = new mongoose.Schema({
    topicName: String,
    desc: String,
    authorID: String,
    isPublic: Boolean,
    createAt:{
        type: Date,
        default: dateVietnam
    }

})


module.exports = mongoose.model('topic', TopicSchema)