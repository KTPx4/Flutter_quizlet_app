const mongoose = require('mongoose')

let AccountSchema = new mongoose.Schema({
    fullName: String,
    user: String,
    passWord: String,
    email:{
        type: String,
        unique: true
    },
    phone: {
        type: String,
        default: null
    },
    nameAvt: {
        type: String,
        default: null
    },

})

// Thêm hook để đặt giá trị mặc định cho các dòng đã có dữ liệu
AccountSchema.pre('save', function (next) {
    // Nếu giá trị của 'NameAvt' là null hoặc không được xác định, đặt giá trị mặc định là '_id.png'
    if (!this.nameAvt || this.nameAvt === null) {
        this.nameAvt = this._id + '.png';    
    }
    next();
});
module.exports = mongoose.model('account', AccountSchema)