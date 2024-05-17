const CombineModel = require('../models/CombineWordModel')
const StudyWord = require('../models/StudyCombine')
const CustomError = require('../modules/CustomError')
const ConverData = require('../modules/ConvertData')

module.exports.MarkWord = async (req, res) =>{
    try{
        
        var idw = req.params.id
        var idu = req.vars.User._id
    
        var studyWord = req.vars.StudyWord
        var mark = ! (studyWord.isMark)
     
        var markWord =await StudyWord.findOneAndUpdate({combineID: idw, accountID: idu}, {isMark: mark}, {new: true})

    
        return res.status(200).json({
            message: "Thay đổi trạng thái của từ thành công"
            // data: await ConverData.formatListWord(idu, markWord)
        })

    }
    catch(err)
    {
        console.log("Error at StudyController - markword: ", err);
        return res.status(500).json({
            message: "Vui lòng thử lại sau"
        })
    }

    
}

module.exports.StudyWord = async (req, res) =>{
    try{

        var idw = req.params.id
        var idu = req.vars.User._id
    
        var studyWord = req.vars.StudyWord
        var count = studyWord.studyCount + 1
        var markWord = await StudyWord.findOneAndUpdate({combineID: idw, accountID: idu}, {studyCount: count})
    
        return res.status(200).json({
            message: "Cập nhật số lần học thành công"
        })

    }
    catch(err)
    {
        console.log("Error at StudyController - StudyWord: ", err);
        return res.status(500).json({
            message: "Vui lòng thử lại sau"
        })
    }


}
