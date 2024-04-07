const emailValidator = require('email-validator')
const AccountModel = require('../../models/AccountModel')
const bcrypt = require('bcrypt')


module.exports.Regiser = async (req, res, next) =>{
    try
    {
        let {email, password} = req.body
        email= email?.toLowerCase()
        let user = email?.split('@')[0]
        let message = ''
    
        if(!email)
            message = "Vui lòng nhập Email"    
        else if(!emailValidator.validate(email))
            message = "Email không hợp lệ" 
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
        if(accByEmail)
        {
            return res.status(400).json({            
                message: "Email đã tồn tại"
            })
        }
    
        var index = 0
        while(await AccountModel.findOne({user: user}))
        {
            user = `${user}${index}`
            index++
        }
    
        req.vars.userName = user
    
        return next()

    }
    catch(err)
    {
        console.log("Error at validator Account - Register: ", err);
        return res.status(500).json({
            status: "Error Server When Register",
            message: "Thao tác không thành công. Vui lòng thử lại sau!",
            data: {
                email,
                user,
                password
            }
        })
    }  
   
}

module.exports.Login = async (req, res, next) =>{


    try
    {
        let {email, user, password} = req.body
        email= email?.toLowerCase()
        user= user?.toLowerCase()
        
        let message = ''
    
        if(!email && !user)
            message = "Vui lòng nhập bằng Email hoặc UserName" 
        else if(!password)
            message = "Vui lòng nhập mật khẩu"
    
        if(message)
        {
            return res.status(400).json({
                message: message
            })
        }
        
        let Account
       
        // Find Account
        if(email)
            Account = await AccountModel.findOne({email: email})
        else
            Account = await AccountModel.findOne({user: user})

        // Checking Pass if exists
        if(!Account)
            message =  "Tài khoản không tồn tại"
        else
        {
            var PassMatch = await bcrypt.compare(password, Account.passWord)
            message = PassMatch? null : "Mật khẩu không đúng"
        }

        // Return error if exists
        if(message)
            return res.status(400).json({
                status: "Error at Client - Account not valid",
                message: message,
                data: {
                    email,
                    user,
                    password
                }
            })

        req.vars.User = Account

        return next()
        
    }
    catch(err)
    {
        console.log("Error at validator Account - Login: ", err);
        return res.status(500).json({
            status: "Error Server When Login",
            message: "Thao tác không thành công. Vui lòng thử lại sau!",
            data: {
                email,
                user,
                password
            }
        })
    }  


}

module.exports.ChangeProfile = (req, res, next) =>{
    // If change user -> check exists user
    
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

