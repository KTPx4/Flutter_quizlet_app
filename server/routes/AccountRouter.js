const express = require('express')
const _APP = express.Router()

//Middleware
const AccountValidator = require('../middlewares/Account/Validator')
const Auth = require('../middlewares/Account/Auth')
//Controller
const AccountControler = require('../controllers/AccountController')

_APP.get('/', AccountControler.getAll)

_APP.get('/validate', Auth.AuthAccount, AccountControler.validAuth)

// register account
_APP.post('/register', AccountValidator.Regiser, AccountControler.Register)

// login
_APP.post('/login', AccountValidator.Login, AccountControler.Login)


// change password
_APP.post('/changepass', Auth.AuthAccount, AccountValidator.ChangePassword, AccountControler.ChangePassword)

// Get code reset
_APP.post('/getcode',  AccountValidator.GetCode, AccountControler.GetCode)

// Get valid code reset
_APP.post('/validcode',  AccountValidator.ValidCode, AccountControler.ValidCode)

// Get valid code reset
_APP.post('/reset', Auth.AuthAccount, AccountValidator.ResetPass, AccountControler.ChangePassword)


module.exports = _APP