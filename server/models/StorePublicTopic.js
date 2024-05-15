const mongoose = require('mongoose')

let StoreTopicSchema = new mongoose.Schema({
    topicID: String,
    accountID: String,
})


module.exports = mongoose.model('storepublictopic', StoreTopicSchema)