const express = require('express')
const _APP = express.Router()

//Middleware
const AccountValidator = require('../middlewares/Account/Validator')
//Controller
const AccountControler = require('../controllers/AccountController')

_APP.get('/register', (req, res)=>{
    return res.status(200).json({
        message: "Register account: email, user, password"
    })
})
_APP.post('/register', AccountValidator.Regiser, AccountControler.Register)



module.exports = _APP