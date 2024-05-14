const FolderModel = require('../models/FolderModel')
const TopicModel = require('../models/TopicModel')
const StoreTopic = require('../models/StoreTopicModel')
const ConverData = require('../modules/ConvertData')

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
    
        var resultFolder = await ConverData.formatListFolder(ListTopic)
        
    
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
            data: ConverData.con(newFolder)
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