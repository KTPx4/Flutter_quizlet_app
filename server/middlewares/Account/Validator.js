const emailValidator = require('email-validator')
const AccountModel = require('../../models/AccountModel')
const CodeModel = require('../../models/ResetAccount')

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
            index++
        }
        if(index !== 0)
            user = `${user}${index}`
    
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
        let { user, password} = req.body
        // email= email?.toLowerCase()
        user= user?.toLowerCase()
        
        let message = ''
    
        if(!user)
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
        if(user)
            Account = await AccountModel.findOne({user: user})

        if(!Account)
            Account = await AccountModel.findOne({email: user})

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

module.exports.ChangePassword = async (req, res, next) =>{
    
    let {oldPass, newPass} = req.body

    let Account = req.vars.User

    // console.log(`oldPass: ${oldPass} - newPass: ${newPass} - AccountPass: ${Account.passWord}`);

    if(!oldPass || !newPass)
        return res.status(400).json({
            status: 'Null request data',
            message: 'Vui lòng cung cấp mật khẩu mới và mật khẩu cũ'
        })

    if(!Account)
         return res.status(400).json({
            status: 'Account has been null',
            message: 'Không thể tìm thấy tài khoản'
        })

    await bcrypt.compare(oldPass, Account.passWord)
    .then(passMatch => {
        if(!passMatch)
            throw new Error('Mật khẩu cũ không đúng')

        if(oldPass == newPass)
            throw new Error('Mật khẩu mới không được trùng với mật khẩu cũ')

        return next()
    })
    .catch(err =>{
        return res.status(400).json({
            status: 'Change Password Failed',
            message: err.message
        })
    })

   
}

module.exports.GetCode = async (req, res, next) =>{
    try{

        let {email} = req.body
        if(!email)
        {
            return res.status(400).json({
                status: "Get code reset failed",
                message: "Vui lòng cung cấp email"
            })
        }

        var Account = await AccountModel.findOne({email: email})
        if(!Account)
        {
            return res.status(400).json({
                status: "Get code reset failed",
                message: "Email này chưa có tài khoản!"
            })
        }

        req.vars.User = Account

        return next()
    }
    catch(err)
    {
        console.log("Error at Validator - GetCode: \n" + err)
        return res.status(500).json({
            status: "Get code reset failed",
            message: "Server đang bận. Vui lòng  thử lại sau!"
        })
    }
   
}

module.exports.ValidCode = async (req, res, next) =>{
    try{
      
        let {code, email} = req.body
        var mess = ""
        if(!email)
        {
            mess = "Vui lòng cung cấp email"
        }
        if(!code)
        {
            mess = "Vui lòng cung cấp code"
        }
        if(mess)
        {
            return res.status(400).json({
                status: 'Reset password Failed',
                message: mess
            })
        }    

        var Account = await AccountModel.findOne({email: email})
        if(!Account)
        {
            return res.status(400).json({
                status: "Reset password failed",
                message: "Email này chưa có tài khoản!"
            })
        }
        
        var ResetCode = await CodeModel.findOne({id: Account._id})

        if(!ResetCode || ResetCode.code !== code)
        {
           

            return res.status(400).json({
                status: "Code invalid",
                message: "Code không đúng hoặc hết hạn"
            })
        }
        
        req.vars.User = Account

        return next()
    }
    catch(err)
    {
        console.log("Error at Validator - GetCode: \n" + err)
        return res.status(500).json({
            status: "Get code reset failed",
            message: "Server đang bận. Vui lòng  thử lại sau!"
        })
    }
   

}

module.exports.ResetPass = async (req, res, next) =>{
    try{
        let {newPass} = req.body
       
        if(!newPass)
        {
            return res.status(400).json({
                status: 'Reset password Failed',
                message: "Vui lòng cung cấp mật khẩu mới"
            })
        }  
        

        return next()
    }
    catch(err)
    {
        console.log("Error at Validator - GetCode: \n" + err)
        return res.status(500).json({
            status: "Get code reset failed",
            message: "Server đang bận. Vui lòng  thử lại sau!"
        })
    }
   

}

module.exports.Edit = async(req, res, next) =>{
    let {email, fullName} = req.body
    email = email?.toLowerCase()
    if(!email && !fullName)
        return res.status(400).json({
            message: "Vui lòng nhập email hoặc fullName"
        })
        
    else if(email && !emailValidator.validate(email))
        return res.status(400).json({
            message: "Email không hợp lệ"
        })

    if(email)
    {      
        email = email.toLowerCase()
        var account = await AccountModel.findOne({email: email})
        if(account)
        {
            return res.status(400).json({
                message: "Email này đã có tài khoản"
            })        
        }
    }
    
    return next()

}


module.exports.UpdateProfile = async(req, res, next)=>
{
    let file = req.file
    if(!file)
    {
        return res.status(400).json({
            message: "Vui lòng cung cấp ảnh"
        })
    }
    return next()

    

}