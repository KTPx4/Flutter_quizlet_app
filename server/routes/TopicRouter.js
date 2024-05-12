const express = require('express');
const _APP = express.Router()
const TopicController = require("../controllers/TopicController")
const Validator = require("../middlewares/Topic/Validator")
const Auth = require('../middlewares/Account/Auth')

_APP.get('/', Auth.AuthAccount, TopicController.GetAll)


_APP.post('/',  Auth.AuthAccount, Validator.Add,TopicController.Add)

_APP.get('/public', Auth.AuthAccount, TopicController.GetPublic)

_APP.get('/:id', Auth.AccessTopic, TopicController.GetByID)

_APP.delete('/:id', Auth.CRUDTopic, TopicController.Delete)







module.exports = _APP