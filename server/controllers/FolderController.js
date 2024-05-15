const FolderModel = require('../models/FolderModel')
const TopicModel = require('../models/TopicModel')
const StoreTopic = require('../models/StoreTopicModel')
const ConverData = require('../modules/ConvertData')
const CustomError = require("../modules/CustomError")

module.exports.GetAll = async(req, res) =>{
    try{
        var Account = req.vars.User
        var idu = Account._id

        var ListFolder = await FolderModel.find({authorID: idu})

        if(!ListFolder || ListFolder.length < 1)
        {
            return res.status(200).json({
                message:"Chưa có folder nào. Hãy tạo thêm để xem",
                count: 0,
                data: null
            })
        }   
    
        var resultFolder = await ConverData.formatListFolder(ListFolder)
        
    
        return res.status(200).json({
            message: "Lấy thành công danh sách folder",
            count: ListFolder.length,
            data: resultFolder
        })
    }
    catch(err)
    {
        console.log("Error Add FolderController - GetAll: " , err);

        return res.status(500).json({
            message: "Server đang bận. Vui lòng thử lại sau!"
        })
    }   
}


module.exports.GetByID = async(req, res) =>{
    try{
        let folderID = req.params.id
    
        var listFolder = await FolderModel.find({_id: folderID})
    
        var resultFolders = await ConverData.formatListFolder(listFolder)    
    
        return res.status(200).json({
            message: `Lấy thành công folder '${folderID}'`,
            data: {...resultFolders }[0]      
            
        })

    }
    catch(err)
    {
        console.log("Error Add FolderController - GetByID: " , err);
        return res.status(500).json({
            message: "Lấy thư mục thất bại. Vui lòng thử lại sau!"
        })
    }
}

module.exports.Add = async(req, res) =>{
    try{
        var Account = req.vars.User

        var idu = Account._id

        var {folderName, desc} = req.body

        var newFolder = await FolderModel.create({
            folderName,
            desc,
            authorID: idu
        })

      

        return res.status(200).json({
            message: "Thêm thành công thư mục",
            data: ConverData.convertFolder(newFolder)
        })

    }
    catch(err)
    {
        console.log("Error Add FolderController - Add: " , err);
        return res.status(500).json({
            message: "Thêm thư mục thất bại. Vui lòng thử lại sau!"
        })
    }



}


module.exports.Delete = async(req, res) => {
    try{
        let folderID = req.params.id
        var folder = await FolderModel.findOneAndDelete({_id: folderID})

        var storeTopic = await StoreTopic.find({folderID: folderID})

        for(let store of storeTopic)
        {
            await StoreTopic.findOneAndDelete({_id: store._id})   
        }
        // delete topic in folder - or set message: topic not has deleted

        return res.status(200).json({
            message: `Xóa thành công thư mục '${folderID}'`,
            data: ConverData.convertFolder(folder)
        })
    }
    catch(err)
    {
        console.log("Error Add FolderController - Delete: " , err);

        return res.status(500).json({
            message: "Server đang bận. Vui lòng thử lại sau!"
        })
    }
}

module.exports.Edit =async (req, res) =>{
    try{
        var folderID = req.params.id
        var Account = req.vars.User
        var idu = Account._id

        var {folderName, desc} = req.body

        var editFolder = await FolderModel.findOneAndUpdate({_id: folderID},{
            folderName: folderName,
            desc: desc,          
        }, {new: true})


        
        var result = [{
            ...ConverData.convertFolder(editFolder),

        }]
        
        
        return res.status(200).json({
            message: `Cập nhật thành công '${folderID}'`,
            data: result[0]
        })

    }
    catch(err)
    {
        if (!(err instanceof CustomError)) {
            console.log("Error at FolderController - edit: ", err.message);
        }
    
        return res.status(500).json({
            message: err.message
        })
    }
}


module.exports.AddTopic = async(req, res) =>{
    let count = 0
    try{

        let {id} = req.params
        let {topics} = req.body
        var uid = req.vars.User._id.toString()
        var listtopics = await Promise.all(topics.map(async (idTopic) => {   
            var topic = await TopicModel.findOne({_id: idTopic})
            var store = await StoreTopic.findOne({topicID: idTopic, folderID: id})

            if(!topic)
            {
                throw new CustomError(`Topic '${idTopic}' không tồn tại`)
            }
            else if(store)
            {
                throw new CustomError(`Topic '${idTopic}' đã có trong thư mục`)                
            }
            else if(topic.authorID !== uid && !topic.isPublic)
            {
                throw new CustomError(`Topic '${idTopic}' không được phép truy cập`)                
            }
            else
            {
                count++
                await StoreTopic.create({
                    folderID: id,
                    topicID: idTopic
                })
            }
        }));

        return res.status(200).json({
            message: `Đã thêm thành công ${count} chủ đề vào thư mục`,          
        })

    }
    catch(err)
    {
        var code = 500, mess = "Server đang bận. Vui lòng thử lại sau"
        if(err instanceof CustomError)
        {
            mess = err.message + `. ${count} chủ đề đã được thêm vào`
            code = 400
        }
        else{
            console.log("Error At FodlerController - AddTopic: ", err);
        }
        return res.status(code).json({
            message: mess
        })
    }
}

module.exports.DelTopicfromFolder = async(req, res) =>{
    try{
        let {topicid, id} = req.params
        var store = await StoreTopic.findOneAndDelete({topicID: topicid, folderID: id})
        return res.status(200).json({
            message: "Xóa thành công chủ đề ra khỏi thư mục",
            data: store
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

