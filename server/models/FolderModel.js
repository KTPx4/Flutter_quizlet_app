const mongoose = require('mongoose')
const moment = require('moment-timezone');
const dateVietnam = moment.tz(Date.now(), "Asia/Ho_Chi_Minh");
let FolderSchema = new mongoose.Schema({
    folderName: String,
    desc: String,
    authorID: String,
    // isPublic: Boolean,
    createAt:{
        type: Date,
        default: dateVietnam
    }
    
})


module.exports = mongoose.model('folder', FolderSchema)