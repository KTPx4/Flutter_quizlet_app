const jwt = require('jsonwebtoken')
const SECRET_LOGIN = process.env.KEY_SECRET_LOGIN || 'key-login'
const AccountModel = require('../../models/AccountModel')
const TopicModel = require("../../models/TopicModel")
const CustomError = require("../../modules/CustomError")
const FolderModel = require('../../models/FolderModel')

const bcrypt = require('bcrypt')

const AuthAccount = async (req, res, next) =>{
    try{
        // Get token from header or body
        let tokenFromHeader =  req.header('Authorization')
    
        let token = undefined
    
        if(!tokenFromHeader)
            token =  req.body.token  
    
        else
            token = tokenFromHeader.split(' ')[1]
    
    
        if(!token || token === undefined)
        {
            return res.status(401).json({
                status: "Authorization",           
                message: 'Vui lòng cung cấp token mới có quyền truy cập'
            })
        }

        // verify token
    
        await jwt.verify(token, SECRET_LOGIN, async(err, data)=>{
            if(err)
            {
                return res.status(400).json({
                   status: 'Invalid Token',
                    message: 'Đăng nhập thất bại hoặc phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!'
                })
            }
            let emailU = data.email?.toLowerCase()
            let userU = data.user?.toLowerCase()
            var pass = data.passWord
  
            let account 
            if(emailU)
            {
                account = await AccountModel.findOne({               
                        email: emailU,               
                })
            }
            else if(userU)
            {
                account = await AccountModel.findOne({               
                        user: userU,               
                })
            }
            
            if(!account)
            {
                return res.status(401).json({
                    status: 'Account not exists',
                    message: 'Tài khoản không tồn tại hoặc vừa bị xóa, không thể đăng nhập'
                })
            }
     
            if(!pass)
            {
                return res.status(401).json({
                    status: 'Password not match',
                    message: 'Mật khẩu đã được thay đổi. Vui lòng đăng nhập lại!'
                })
            }
            var old = account.passWord
    
            
            if(old != pass )
            {
                return res.status(403).json({
                    status: 'Password not match',
                    message: 'Mật khẩu đã được thay đổi. Vui lòng đăng nhập lại!'
                })
            }
        
            req.vars.User = account
    
            return next()
        })
    }
    catch(err)
    {
        console.log("Error at Auth - AuthAccount: ", err);
        return res.status(500).json({
            status: "Error Server",
            message: "Vui lòng thử lại sau"
        })
    }
   

  
}

const authAccessTopic =  async ( req, res, next) =>{
    await AuthAccount(req, res, async() =>{
        try{
            var topicID = req.params.id
            var Account = req.vars.User
            var uid = Account._id.toString()
            
            var Topic = await TopicModel.findOne({_id: topicID})
            if(!Topic)
            {
                throw new CustomError("Topic không tồn tại hoặc vừa bị xóa")
            }
            if(Topic.authorID !== uid && !Topic.isPublic)
            {
                throw new CustomError("Tài khoản của bạn không có quyền truy cập vào Topic này")
            }
            return next()
        }
        catch(err)
        {
            var mess = err.message, code = 400
            if (!(err instanceof CustomError)) {
                console.log("Error at Auth.js - AccessTopic: ", err);
                mess = "Server đang bận. Vui lòng thử lại sau"
                code = 500
            }
            return res.status(code).json({
                message: mess
            })
        }
        
    })
}

const authCRUD_Topic = async (req, res, next) =>
{
    await AuthAccount(req, res, async() =>{
        try{
            var topicID = req.params.id
            var Account = req.vars.User
            var uid = Account._id.toString() // get from login token
            
            var Topic = await TopicModel.findOne({_id: topicID})
            if(!Topic)
            {
                throw new CustomError("Topic không tồn tại")
            }
            if(Topic.authorID !== uid)
            {
                console.log(Topic.authorID);
                console.log(uid);
                throw new CustomError("Tài khoản của bạn không có quyền truy cập vào Topic này")
            }
            return next()
        }
        catch(err)
        {
            if (!(err instanceof CustomError)) {
                console.log("Error at Auth.js - authCRUD_Topic: ", err);
            }
            return res.status(400).json({
                message: err.message
            })
        }

        
    })    
}

const authCRUD_Folder = async (req, res, next) =>
{
    await AuthAccount(req, res, async() =>{
        try{
            var folderID = req.params.id
            var Account = req.vars.User
            var uid = Account._id.toString() // get from login token
            
            var Folder = await FolderModel.findOne({_id: folderID})
            if(!Folder)
            {
                throw new CustomError("Thư mục không tồn tại")
            }
            if(Folder.authorID !== uid)
            {
                throw new CustomError("Tài khoản của bạn không có quyền truy cập vào thư mục này")
            }
            return next()
        }
        catch(err)
        {
            if (!(err instanceof CustomError)) {
                console.log("Error at Auth.js - authCRUD_Folder: ", err);
            }
            return res.status(400).json({
                message: err.message
            })
        }

        
    })    
}


module.exports.AuthAccount = AuthAccount
module.exports.AccessTopic = authAccessTopic
module.exports.CRUDTopic = authCRUD_Topic
module.exports.CRUDFolder = authCRUD_Folder
