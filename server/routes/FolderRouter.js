const express = require('express');
const _APP = express.Router()
const FolderController = require('../controllers/FolderController')
const Auth = require('../middlewares/Account/Auth')


_APP.get("/", Auth.AuthAccount, FolderController.GetAll)


module.exports = _APP