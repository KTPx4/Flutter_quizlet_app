const emailValidator = require('email-validator')
const AccountModel = require('../../models/AccountModel')




module.exports.Regiser = async (req, res, next) =>{
    let {email, user, password} = req.body
    email= email.toLowerCase()
    
    let message = ''

    if(!email)
        message = "Vui lòng nhập Email"    
    else if(!emailValidator.validate(email))
        message = "Email không hợp lệ" 
    else if(!user)
        message = "Vui lòng nhập tên đăng nhập"
    else if(!password)
        message = "Vui lòng nhập mật khẩu"
    else if(password.length < 5)
        message = "Mật khẩu phải ít nhất 5 ký tự"
   
    if(message)
    {
        return res.status(400).json({
            message: message
        })
    }

    var accByEmail = await AccountModel.findOne({email: email})
    var accByUser = await AccountModel.findOne({user: user})
    if(accByEmail)
    {
        return res.status(400).json({            
            message: "Email đã tồn tại"
        })
    }

    if(accByUser)
    {
        return res.status(400).json({    
            message: "Tên đăng nhập đã tồn tại"
        })
    } 

    return next()
}

module.exports.Login = (req, res, next) =>{
    
    
    return next()
}

module.exports.ChangeProfile = (req, res, next) =>{
    
    
    return next()
}

module.exports.ChangePassword = (req, res, next) =>{
    
    
    return next()
}

module.exports.GetCodeReset = (req, res, next) =>{
    
    
    return next()
}

module.exports.ResetPassword = (req, res, next) =>{
    
    
    return next()
}