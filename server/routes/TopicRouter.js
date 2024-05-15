const express = require('express');
const _APP = express.Router()
const TopicController = require("../controllers/TopicController")
const Validator = require("../middlewares/Topic/Validator")
const Auth = require('../middlewares/Account/Auth')

_APP.get('/', Auth.AuthAccount, TopicController.GetAll)
_APP.post('/',  Auth.AuthAccount, Validator.Add, TopicController.Add)

// for public topic
_APP.get('/public', Auth.AuthAccount, TopicController.GetPublic)
// _APP.post('/public/:id', Auth.AccessTopic, TopicController.StorePublic)
// _APP.delete('/public/:id', Auth.AccessTopic, TopicController.RemoveStore)

// api for add words and get words
_APP.post('/:id/word', Auth.CRUDTopic, Validator.AddWords, TopicController.AddWords)
_APP.get('/:id/word', Auth.CRUDTopic, TopicController.GetAllWords)
_APP.delete('/:id/word/:wordid', Auth.CRUDTopic, Validator.DeleteWord, TopicController.DeleteWord)

// for topic
_APP.get('/:id', Auth.AccessTopic, TopicController.GetByID)

_APP.delete('/:id', Auth.CRUDTopic, TopicController.Delete)

_APP.patch('/:id', Auth.CRUDTopic, Validator.Edit, TopicController.Edit)







module.exports = _APP