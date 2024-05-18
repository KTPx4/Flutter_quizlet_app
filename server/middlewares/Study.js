const StudyCombineModel = require('../models/StudyCombine')
const StudyTopic = require('../models/StudyTopic')
const CombineModel = require('../models/CombineWordModel')

module.exports.CreateStudyWord = async(req, res, next) =>{
  
    var idu = req.vars.User._id
    let idw = req.query.wordid; // Lấy tham số truy vấn 'wordid' từ URL
    
    if(idw)
    {
        var combine = await CombineModel.findOne({_id: idw})
        if(!combine)
        {
            return res.status(400).json({
                message: "Từ vựng không tồn tại"
            })
        }
        else
        {
            var study = await StudyCombineModel.findOne({combineID: idw, accountID: idu})
            if(!study)
            {
                
                study = await StudyCombineModel.create({
                    combineID: idw,
                    accountID: idu
                })
            }   
        
            req.vars.StudyWord = study
            return next()
        }
    }
    else{
        return next()
    }

}

module.exports.StudyTopic = async(req, res, next) =>{
    let idt = req.params.id
    let idu = req.vars.User._id

    var study  = await StudyTopic.findOne({topicID: idt, accountID: idu})
    if(!study)
    {
        study  = await StudyTopic.create({topicID: idt, accountID: idu})
    }

    req.vars.StudyTopic = study

    return next();

}