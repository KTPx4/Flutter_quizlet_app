const jwt = require('jsonwebtoken')
const SECRET_LOGIN = process.env.KEY_SECRET_LOGIN || 'key-login'
const AccountModel = require('../../models/AccountModel')

module.exports.AuthAccount = (req, res, next) =>{
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
            return res.status(400).json({
                status: "Authorization",           
                message: 'Vui lòng đăng nhập mới có quyền truy cập'
            })
        }

        // verify token
    
        jwt.verify(token, SECRET_LOGIN, async(err, data)=>{
            if(err)
            {
                return res.status(400).json({
                   status: 'Invalid Token',
                    message: 'Đăng nhập thất bại hoặc phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại!'
                })
            }
    
            let emailU = data.email?.toLowerCase()
            let userU = data.user?.toLowerCase()
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
    
            req.vars.User = account
    
            return next()
        })
    }
    catch(err)
    {
        console.log("Error at Auth - AuthAccount: ", err);
        return res.stauts(500).json({
            status: "Error Server",
            message: "Vui lòng thử lại sau"
        })
    }
   

  
}