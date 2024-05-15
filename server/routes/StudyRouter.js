const express = require('express');
const _APP = express.Router()
const StudyController = require("../controllers/StudyController")
const StudyMiddleware = require('../middlewares/Study')

const Auth = require('../middlewares/Account/Auth')

_APP.get('/mark/:id', Auth.AuthAccount, StudyMiddleware.CreateStudyWord , StudyController.MarkWord)
_APP.get('/:id', Auth.AuthAccount, StudyMiddleware.CreateStudyWord , StudyController.StudyWord)

module.exports = _APP