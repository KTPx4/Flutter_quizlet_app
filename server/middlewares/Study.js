const StudyCombineModel = require('../models/StudyCombine')

module.exports.CreateStudyWord = async(req, res, next) =>{
    var idw = req.params.id
    var idu = req.vars.User._id
    var study = await StudyCombineModel.findOne({combineID: idw, accountID: idu})
    if(!study)
    {
        console.log("Create");
        study = await StudyCombineModel.create({
            combineID: idw,
            accountID: idu
        })
    }
    
    req.vars.StudyWord = study

    return next()
}