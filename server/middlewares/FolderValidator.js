
const CustomError = require("../modules/CustomError")
var ObjectId = require('mongoose').Types.ObjectId;
const StoreTopicModel = require('../models/StoreTopicModel')
module.exports.Add = async(req, res, next) =>
{
    try{
        var {folderName, desc } = req.body

        if(!folderName)
            throw new CustomError("Thiếu folderName")

        return next()    
    }
    catch(err)
    {
        if (!(err instanceof CustomError)) {
            console.log("Error at Validator Folder - Add: ", err.message);
        }
        return res.status(400).json({
            message: err.message
        })
    }

}
    

module.exports.AddTopic = async(req, res, next) =>{
    try{
  
        let {topics} = req.body

        
        if(!topics || topics == null)
            throw new CustomError("Thiếu danh sách chủ đề: topics")
        else if(topics.length < 1)
            throw new CustomError("Danh sách chủ đề phải có ít nhất 1 chủ đề")
        
        topics?.forEach(id => {            
            if(!ObjectId.isValid(id))
                throw new CustomError("Thiếu id của chủ đề hoặc id không đúng")
        })
        return next()
    }
    catch(err)
    {
        var code = 500, mess = "Server đang bận. Vui lòng thử lại sau"
        if(err instanceof CustomError)
        {
            mess = err.message
            code = 400
        }
        else{
            console.log("Error At Validator Folder - AddTopic");
        }
        return res.status(code).json({
            message: mess
        })
    }


}

module.exports.DeleteTopic= async (req, res, next) =>{
    try{
        let {topicid, id} = req.params
        var store = await StoreTopicModel.findOne({topicID: topicid, folderID: id})
        if(!store)
        {
            return res.status(400).json({
                message: "Chủ đề không tồn tại trong thư mục này hoặc đã bị xóa"
            })
        }
        
        return next()
    }
    catch(err)
    {
        console.log("Error at validator folder - DeleteTopic: \n", err);
        return res.status(500).json({
            message: "Server đang bận. Vui lòng thử lại sau"
        })
    }
}