const mongoose = require('mongoose')

var ResetCode = new mongoose.Schema({
    code: String,
    id: String,
    createdAt: { type: Date, expires: '5m', default: Date.now }
});

  module.exports = mongoose.model('ResetAccount', ResetCode)