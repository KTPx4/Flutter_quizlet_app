const mongoose = require('mongoose')

let StoreTopicSchema = new mongoose.Schema({
    topicID: String,
    folderID: String,
})


module.exports = mongoose.model('storetopic', StoreTopicSchema)