const CustomError = require("../modules/CustomError")
const CombineModel = require("../models/CombineWordModel")
const FolderModel = require('../models/FolderModel')
const TopicModel = require('../models/TopicModel')
const StoreTopic = require('../models/StoreTopicModel')
const StudyCombineModel = require('../models/StudyCombine')

const StudyTopicModel = require('../models/StudyTopic')

const formatListWord = async (idu, listCombine) => {
    var listWords = []

    for(let word of listCombine)
    {
        var study = await StudyCombineModel.findOne({combineID: word._id, accountID: idu})
        if(!study)
        {
      
            study = await StudyCombineModel.create({
                combineID: word._id,
                accountID: idu
            })
        }

        listWords.push({
            "_id": word._id,
            "desc": word.desc,
            "img": word.img,
            "mean1": word.mean1,
            "mean2": word.mean2,
            "isMark": study.isMark,
            "studyCount": study.studyCount 

        })
    }
    return listWords
}

const formatListTopic = async (idu, ListTopic) => {
    var resultTopics = await Promise.all(ListTopic.map(async (topic)=>{
        var listCombine = await CombineModel.find({topicID: topic._id})
        var listWords =  await formatListWord(idu, listCombine)

        var studyTopic = await StudyTopicModel.findOne({accountID: idu, topicID: topic._id})
        if(!studyTopic)
        {
            studyTopic = await StudyTopicModel.create({accountID: idu, topicID: topic._id})
        }

        // console.log(topic);
        return {
            ...convertTopic(topic),
            "countWords": listCombine.length,
            "studyCount": studyTopic.studyCount,
            "words": listWords
        }
    }))

    return resultTopics
}

const formatListFolder = async (idu, ListFolder) => {
    var resultTopics = await Promise.all(ListFolder.map(async (folder)=>{
        var storeTopic = await StoreTopic.find({folderID: folder._id})
       
        var listIDTopic = storeTopic.map(e => e.topicID)
        var listTopics = []
        for(let id of listIDTopic)
        {
          
            var topic = await TopicModel.findOne({_id: id})
            if(topic)
            {
                listTopics.push(topic)
            }
        }
        
        listTopics = await formatListTopic(idu, listTopics)
  
        return {
            ...convertFolder(folder),
            "countTopic": listTopics.length,
            "topics": listTopics
        }
    }))

    return resultTopics
}

const convertTopic = (topic) =>{
    return {
        "_id": topic._id,
        "topicName": topic.topicName,
        "desc": topic.desc,
        "authorID": topic.authorID,
        "isPublic": topic.isPublic,
        "createAt": formatTime(topic.createAt),
    }
}

const convertFolder = (folder) =>{
    return {
        "_id": folder._id,
        "folderName": folder.folderName,
        "desc": folder.desc,
        "authorID": folder.authorID,
        // "isPublic": folder.isPublic,
        "createAt": formatTime(folder.createAt),
    }
}


const formatTime = (time) =>{
    var utcDate = new Date(time);
    var localDate = utcDate.toLocaleString('vi-VN', { timeZone: 'Asia/Ho_Chi_Minh' });
    return localDate
}

module.exports.formatListWord = formatListWord
module.exports.formatListTopic = formatListTopic
module.exports.formatListFolder = formatListFolder
module.exports.convertTopic = convertTopic
module.exports.convertFolder = convertFolder
module.exports.formatTime = formatTime
