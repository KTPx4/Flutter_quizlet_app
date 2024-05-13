const CustomError = require("../../modules/CustomError")
const TopicModel = require('../../models/TopicModel')
const CombineWordModel = require("../../models/CombineWordModel")

module.exports.Add = async(req, res, next) =>
{
    try{
        var {topicName, desc, isPublic, } = req.body

        if(!topicName)
            throw new CustomError("Thiếu topicName")
        if(!desc)
            throw new CustomError("Thiếu desc")
        if(isPublic == null || !(typeof isPublic === "boolean"))
            throw new CustomError("Thiếu isPublic hoặc không đúng kiểu boolean")
        // if(!words || words == null)
        //     throw new CustomError("Thiếu danh sách từ: words")
        // else if(words.length < 1)
        //     throw new CustomError("Danh sách từ phải có ít nhất 1 cặp từ")

        // words?.forEach(combine => {            
        //     if(!combine["mean1"] )
        //         throw new CustomError("Vui lòng cung cấp thuật ngữ: mean1")
        //     if(!combine["mean2"] )
        //         throw new CustomError("Vui lòng cung cấp nghĩa: mean2")

        //     if(!combine["mean1"]["title"] || !combine["mean1"]["lang"])
        //         throw new CustomError("mean1: Vui lòng nhập tên thuật ngữ (title) và ngôn ngữ (lang)")
        //     if(!combine["mean2"]["title"] || !combine["mean2"]["lang"])
        //         throw new CustomError("mean2: Vui lòng nhập tên nghĩa (title) và ngôn ngữ (lang)")
        // });
        return next()    
    }
    catch(err)
    {
        if (!(err instanceof CustomError)) {
            console.log("Error at Validator Topic - Add: ", err.message);
        }
        return res.status(400).json({
            message: err.message
        })
    }

}

module.exports.Edit = async(req, res, next) =>{
    let {id} = req.params
    var topic = TopicModel.findOne({_id: id})
    if(!topic)
    {
        return res.status(400).json({
            message: "Topic không tồn tại"
        })
    }
    else{
        return next()
    }
}

module.exports.AddWords = async(req, res, next) =>{
    try{
        let {id} = req.params
        let {words} = req.body

        var topic = TopicModel.findOne({_id: id})
        if(!topic)
            throw new CustomError(`Topic '${id}' không tồn tại`)
        if(!words || words == null)
            throw new CustomError("Thiếu danh sách từ: words")
        else if(words.length < 1)
            throw new CustomError("Danh sách từ phải có ít nhất 1 cặp từ")
        
        words?.forEach(combine => {            
            if(!combine["mean1"] )
                throw new CustomError("Vui lòng cung cấp thuật ngữ: mean1")
            if(!combine["mean2"] )
                throw new CustomError("Vui lòng cung cấp nghĩa: mean2")

            if(!combine["mean1"]["title"] || !combine["mean1"]["lang"])
                throw new CustomError("mean1: Vui lòng nhập tên thuật ngữ (title) và ngôn ngữ (lang)")
            if(!combine["mean2"]["title"] || !combine["mean2"]["lang"])
                throw new CustomError("mean2: Vui lòng nhập tên nghĩa (title) và ngôn ngữ (lang)")
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
            console.log("Error At Validator Topic - AddWord");
        }
        return res.status(code).json({
            message: mess
        })
    }

    

    return next()
}

module.exports.DeleteWord = async(req, res, next) =>{
    try{
        let {wordid} = req.params
        var word = await CombineWordModel.findOne({_id: wordid})
        if(!word)
        {
            return res.status(400).json({
                message: "Từ vựng này không tồn tại"
            })
        }
        
        return next()
    }
    catch(err)
    {
        console.log("Error at validator - deleteword: \n", err);
        return res.status(500).json({
            message: "Server đang bận. Vui lòng thử lại sau"
        })
    }
}