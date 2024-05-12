const CustomError = require("../../modules/CustomError")

module.exports.Add = async(req, res, next) =>
{
    try{
        var {topicName, desc, isPublic, words} = req.body

        if(!topicName)
            throw new CustomError("Thiếu topicName")
        if(!desc)
            throw new CustomError("Thiếu desc")
        if(isPublic == null || !(typeof isPublic === "boolean"))
            throw new CustomError("Thiếu isPublic hoặc không đúng kiểu boolean")
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
        });
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

