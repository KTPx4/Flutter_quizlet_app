const express = require('express')
const _APP = express.Router()

// Call Controller
const AccountControler = require('../controllers/AccountController')

_APP.get('/login', AccountControler.Login)



module.exports = _APP