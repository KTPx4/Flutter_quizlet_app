const StudyCombineModel = require('../models/StudyCombine')
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