const express = require('express');
const _APP = express.Router()
const FolderController = require('../controllers/FolderController')
const Auth = require('../middlewares/Account/Auth')
const Validator = require("../middlewares/FolderValidator")

_APP.get("/", Auth.AuthAccount, FolderController.GetAll)

_APP.post('/',  Auth.AuthAccount, Validator.Add, FolderController.Add)

_APP.post('/:id/topic', Auth.CRUDFolder, Validator.AddTopic, FolderController.AddTopic)

_APP.delete('/:id/topic/:topicid', Auth.CRUDFolder, Validator.DeleteTopic, FolderController.DelTopicfromFolder)

_APP.get('/:id', Auth.CRUDFolder, FolderController.GetByID)
_APP.delete('/:id', Auth.CRUDFolder, FolderController.Delete)
_APP.patch('/:id', Auth.CRUDFolder,  FolderController.Edit)

module.exports = _APP