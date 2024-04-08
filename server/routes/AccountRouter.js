const express = require('express')
const _APP = express.Router()

//Middleware
const AccountValidator = require('../middlewares/Account/Validator')
const Auth = require('../middlewares/Account/Auth')
//Controller
const AccountControler = require('../controllers/AccountController')


// register account
_APP.get('/register', (req, res)=>{
    return res.status(200).json({
        status: "Way to register",
        message: "Register account: email, user, password"
    })
})
_APP.post('/register', AccountValidator.Regiser, AccountControler.Register)

// login
_APP.get('/login', (req, res)=> {
    return res.status(200).json({
        status: "Way to login",
        message: "Login: email / user, password"
    })
})
_APP.post('/login', AccountValidator.Login, AccountControler.Login)


// change password
_APP.get('/changepass', (req, res)=>{
    return res.status(200).json({
        status: "Way to changepass",
        message: "Header: Baerer {token} \noldPass, newPass"
    })
})
_APP.post('/changepass', Auth.AuthAccount, AccountValidator.ChangePassword, AccountControler.ChangePassword)



module.exports = _APP