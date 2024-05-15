const CustomError = require("../modules/CustomError")
const TopicModel = require("../models/TopicModel")
const CombineModel = require("../models/CombineWordModel")
const StudyWordModel = require("../models/StudyCombine")
const StudyTopicModel = require("../models/StudyTopic")
const StorePublic = require('../models/StorePublicTopic')
var ObjectId = require('mongoose').Types.ObjectId;
const ConverData = require("../modules/ConvertData")

module.exports.GetAll = async(req, res) =>{
    try{
        var Account = req.vars.User
        var idu = Account._id

        var ListTopic = await TopicModel.find({authorID: idu})
        if(!ListTopic || ListTopic.length < 1)
        {
            return res.status(200).json({
                message:"Chưa có topic nào. Hãy tạo thêm để xem",
                count: 0,
                data: null
            })
        }   
    
        var resultTopics =await ConverData.formatListTopic(ListTopic)
        
    
        return res.status(200).json({
            message: "Lấy thành công danh sách topic",
            count: ListTopic.length,
            data: resultTopics
        })
    }
    catch(err)
    {
        return res.status(500).json({
            message: "Server đang bận. Vui lòng thử lại sau!"
        })
    }

}

module.exports.GetAllWords = async(req, res) =>{
    try{

        var Account = req.vars.User
        var idu = Account._id
        var idtopic = req.params.id
        var listCombine = await CombineModel.find({topicID: idtopic})


        if(!listCombine || listCombine.length < 1)
        {
            return res.status(200).json({
                message:"Chưa có từ vựng nào. Hãy tạo thêm để xem",
                count: 0,
                data: null
            })
        }   

        var listWords =  ConverData.formatListWord(listCombine)
        
    
        return res.status(200).json({
            message: "Lấy thành công danh sách từ vựng",
            count: listWords.length,
            data: listWords
        })
    }
    catch(err)
    {
        console.log("Error at TopicController - GetAllWords: ", err);
        return res.status(500).json({
            message: "Server đang bận. Vui lòng thử lại sau!"
        })
    }

}

module.exports.GetByID = async(req, res) =>{
    let topicID = req.params.id

    var ListTopic = await TopicModel.find({_id: topicID})
    if(!ListTopic || ListTopic.length < 1)
    {
        return res.status(200).json({
            message:"Topic không tồn tại hoặc vừa bị xóa",
            count: 0,
            data: null
        })
    }   

    var resultTopics =await ConverData.formatListTopic(ListTopic)    

    return res.status(200).json({
        message: `Lấy thành công Topic '${topicID}'`,
        data: {...resultTopics }[0]      
        
    })
}

module.exports.GetPublic = async (req, res) =>{
    try{

        var ListTopic = await TopicModel.find({isPublic: true})
        if(!ListTopic || ListTopic.length < 1)
        {
            return res.status(200).json({
                message:"Chưa có topic nào. Hãy tạo thêm để xem",
                count: 0,
                data: null
            })
        }   
    
        var resultTopics = await ConverData.formatListTopic(ListTopic)
        
    
        return res.status(200).json({
            message: "Lấy thành công danh sách topic cộng đồng",
            count: ListTopic.length,
            data: resultTopics
            // data: {
            //     topics: resultTopics
            // }
        })
    }
    catch(err)
    {
        return res.status(500).json({
            message: "Server đang bận. Vui lòng thử lại sau!"
        })
    }
}

module.exports.StorePublic = async(req, res)=>{
    try{
        var Tid = req.params.id
        var Uid = req.vars.User
        var storePublic = await StorePublic.find({
            topicID: Tid,
            accountID: Uid
        })
        if(storePublic)
        {
            throw new CustomError("Topic này đã được lưu")
        }

        var newStore = await StorePublic.create({
            topicID: Tid,
            accountID: Uid
        })

        return res.status(200).json({
            message: "Đã thêm topic vào mục lưu trữ"            
        })

    }
    catch(err)
    {
        mess = err.message, code = 400
        if(!(err instanceof CustomError))
        {
            console.log("Error at TopicController - StorePublic: " , err);
            code = 500
            mess = "Server đang bận, vui lòng thử lại sau!z"
        }   
        return res.status(code).json({message: mess})
    }



}
module.exports.RemoveStore = async(req, res)=>{
    try{
        var Tid = req.params.id
        var Uid = req.vars.User
        var storePublic = await StorePublic.findOneAndDelete({
            topicID: Tid,
            accountID: Uid
        })

        if(!storePublic)
        {
            throw new CustomError("Topic này chưa được lưu để xóa")
        }
        else{
            return res.status(200).json({
                message: "Đã xóa topic khỏi mục lưu trữ"            
            })
        }       

    }
    catch(err)
    {
        mess = err.message, code = 400
        if(!(err instanceof CustomError))
        {
            console.log("Error at TopicController - RemoveStore: " , err);
            code = 500
            mess = "Server đang bận, vui lòng thử lại sau!z"
        }   
        return res.status(code).json({message: mess})
    }



}

module.exports.Add = async(req, res) =>{
    try{
        var Account = req.vars.User
        var idu = Account._id
        var {topicName, desc, isPublic} = req.body

        var newTopic = await TopicModel.create({
            topicName: topicName,
            desc: desc,
            authorID: idu,
            isPublic: isPublic
        })

        var idTopic = newTopic._id

        // var listWords = await Promise.all(words.map(async (word) => {

        //     var newcombine = await CombineModel.create({
        //         topicID: idTopic,
        //         desc: word["desc"],
        //         img:  word["img"],
        //         mean1: {
        //             title: word["mean1"]["title"],
        //             lang: word["mean1"]["lang"]
        //         },
        //         mean2: {
        //             title: word["mean2"]["title"],
        //             lang: word["mean2"]["lang"]
        //         },             
              
        //     })
        
        //     return {
        //         "desc": newcombine.desc,
        //         "img": newcombine.img,
        //         mean1: newcombine.mean1,
        //         mean2: newcombine.mean2
        //     }
        // }));
        
        // var result = [{
        //     ...newTopic["_doc"],
        //     "words": listWords
        // }]

        return res.status(200).json({
            message: "Thêm thành công topic",
            data: ConverData.convertTopic(newTopic)
        })

    }
    catch(err)
    {
        console.log("Error Add TopicController - Add: " , err);
        return res.status(500).json({
            message: "Thêm topic thất bại. Vui lòng thử lại sau!"
        })
    }



}

module.exports.Delete = async(req, res) => {
    try{
        let topicID = req.params.id
        var topic =await TopicModel.findOneAndDelete({_id: topicID})
        if(!topic)
        {
            return res.status(400).json({
                message: `Topic '${topicID}' không tồn tại`
            })
        }
        var words = await CombineModel.find({topicID: topicID})
        for(let word of words)
        {
            await CombineModel.findOneAndDelete({_id: word._id})   
        }
        // delete topic in folder - or set message: topic not has deleted

        return res.status(200).json({
            message: `Xóa thành công topic '${topicID}'`,
            data: ConverData.convertTopic(topic)
        })
    }
    catch(err)
    {
        console.log("Error Add TopicController - Delete: " , err);

        return res.status(500).json({
            message: "Server đang bận. Vui lòng thử lại sau!"
        })
    }
}

module.exports.Edit =async (req, res) =>{
    try{
        var topicID = req.params.id
        var Account = req.vars.User
        var idu = Account._id

        var {topicName, desc, isPublic, words} = req.body

        var editTopic = await TopicModel.findOneAndUpdate({_id: topicID},{
            topicName: topicName,
            desc: desc,
            isPublic: isPublic
        }, {new: true})

        var listWords = []

        if(words !== null && words?.length > 0)
        {   

            listWords = await Promise.all(words.map(async (word) => {
                if(!word._id || !ObjectId.isValid(word._id))
                {
                    throw new CustomError("Thiếu id của từ vựng hoặc id không đúng")
                }

                var newcombine = await CombineModel.findByIdAndUpdate({_id: word._id},{
                  
                    desc: word["desc"],
                    img:  word["img"],
                    mean1: {
                        title: word["mean1"]["title"],
                        lang: word["mean1"]["lang"]
                    },
                    mean2: {
                        title: word["mean2"]["title"],
                        lang: word["mean2"]["lang"]
                    },          
                  
                }, {new: true})
            
                return {
                    "desc": newcombine.desc,
                    "img": newcombine.img,
                    mean1: newcombine.mean1,
                    mean2: newcombine.mean2
                }
            }));

        }

        
        var result = [{
            ...ConverData.convertTopic(editTopic),
            "words": listWords
        }]
        
        
        return res.status(200).json({
            message: `Cập nhật thành công '${topicID}'`,
            data: result[0]
        })

    }
    catch(err)
    {
        if (!(err instanceof CustomError)) {
            console.log("Error at TopicController - Edit: ", err.message);
        }
    
        return res.status(500).json({
            message: err.message
        })
    }
}

module.exports.AddWords = async(req, res) =>{
    try{
        // console.log("1 request add word");
        let {id} = req.params
        let {words} = req.body
        let idu = req.vars.User._id

        var listWords = await Promise.all(words.map(async (word) => {   
            var newcombine = await CombineModel.create({
                topicID: id,
                desc: word["desc"],
                img:  word["img"],
                mean1: {
                    title: word["mean1"]["title"],
                    lang: word["mean1"]["lang"]
                },
                mean2: {
                    title: word["mean2"]["title"],
                    lang: word["mean2"]["lang"]
                },             
              
            })

            var studyword = await StudyWordModel.create({
                combineID: newcombine._id,
                accountID: idu,
                isMark: false,                
            })

            return {
                "_id": newcombine._id,
                "desc": newcombine.desc,
                "img": newcombine.img,
                mean1: newcombine.mean1,
                mean2: newcombine.mean2
            }
        }));
        return res.status(200).json({
            message: "Đã thêm thành công từ vựng mới vào topic",
            data: listWords
        })

    }
    catch(err)
    {
        console.log("Error Add TopicController - AddWords: " , err);
        return res.status(500).json({
            message: "Thêm từ vựng vào topic thất bại. Vui lòng thử lại sau!"
        })
    }
}


module.exports.DeleteWord = async(req, res) =>{
    try{
        let {wordid, id} = req.params
        var word = await CombineModel.findOneAndDelete({_id: wordid, topicID: id})
        return res.status(200).json({
            message: "Xóa thành công từ vựng ra khỏi topic",
            data: word
        })
    }
    catch(err)
    {
        console.log("Error Add TopicController - DeleteWord: " , err);
        return res.status(500).json({
            message: "Xóa từ vựng vào topic thất bại. Vui lòng thử lại sau!"
        })
    }

}

