const bcrypt = require('bcrypt')
const AccountModel = require('../models/AccountModel')
const CodeModel = require('../models/ResetAccount')
const fs = require('fs');
const jwt = require('jsonwebtoken');
const { randomInt } = require('crypto');
const SECRET_LOGIN = process.env.KEY_SECRET_LOGIN || 'key-login'
const SECRET_RESET = process.env.PASS_SECRET_RESET || 'key-login'
const sendEmail = require('../modules/mailer')


module.exports.validAuth = (req, res) =>{
    return res.status(200).json({
        message: "Đăng nhập còn hiệu lực",
        data: {
            account: req.vars.User
        }
    })
}

module.exports.getAll = async(req, res) =>{
    try {
        var listAcc = await AccountModel.find();
        return res.status(200).json({
            message: "Get list account",
            data: listAcc
        })
    }
    catch(e)
    {
        return res.status(500).json({
            message: "Error at server",
            data: []
        })
    }
}

module.exports.Register = async (req, res) =>{
    let {email,  password} = req.body
    let {root, userName} = req.vars

    email = email.toLowerCase()
    var account = null
    try{
        bcrypt.hash(password, 10)
        .then(async(hashed) =>{
            const Account = await AccountModel.create({
                fullName: userName,
                email: email,
                user: userName,
                passWord: hashed
            })
            account = Account

            createFolder(root, Account._id, Account.nameAvt) ? null : console.log(`Can't create folder for Account: '${Account._id}' - '${Account.user}'`);
            
            return res.status(200).json({
                message: 'Register Success',
                data: {
                    account: account
                }
            })
        })

    
    }
    catch(err)
    {
        console.log("Error At AccountController - Register: ", err);
        return res.status(500).json({
            message: 'Error At Server',
            data: {}
        })
    }


}

module.exports.Login = async(req, res) =>{
    try{
        const {root, User} = req.vars
        var Account = User
    
        let data  = {
            id: Account._id,
            user: Account.user,
            fullName: Account.fullName,            
            phone: Account.phone,
            email: Account.email,
            avt: Account.nameAvt,
        }
        
        createFolder(root, Account._id, Account.nameAvt) ? null : console.log(`Can't create folder for Account: '${Account._id}' - '${Account.user}'`);
        
        await jwt.sign(data, SECRET_LOGIN, {expiresIn: "30d"}, (err, tokenLogin)=>{
            if(err) throw err
            return res.status(200).json({
                status: "Login success",
                message: "Đăng nhập thành công",
                data: {
                    token: tokenLogin,
                }
            })
        })
    }
    catch(err)
    {
        console.log("Error at AccountController - Login: ", err);
        return res.status(500).json({
            status: "Error Server When Login",
            message: "Lỗi server, vui lòng đăng nhập lại sau!",
            data: {
                email,
                user,
                password
            }
        })
    }  

    
}

module.exports.ChangeProfile = (req, res) => {
    return res.status(200).json({
        message: 'ChangeProfile Success',
        data: {}
    })
}

module.exports.ChangePassword = async (req, res) =>{
    let {newPass} = req.body
    let account = req.vars.User
    try{
        var passHashed = await bcrypt.hash(newPass, 10);

        newAccount = await AccountModel.findOneAndUpdate(
            {email: account.email},
            {passWord: passHashed}
        )
        req.vars.User = newAccount
        return res.status(200).json({
            status: 'Change password success',
            message: 'Đổi mật khẩu thành công'
        })
    }
    catch(err)
    {
        console.log("Error at AccountController - ChangePassword: ", err);
        return res.status(500).json({
            status: "Error Server When Login",
            message: "Server đang bận. Vui lòng  thử lại sau!"
        })
    }
    
}

module.exports.GetCode = async (req, res) =>{
    try{
        var Account = req.vars.User
        var code = Math.floor(1000 + Math.random() * 9000).toString().substring(0, 4)
        var id = Account._id
        
        await CodeModel.deleteMany({id: id}) // 1 account - 1 code

        var ResetCode = await CodeModel.create({
            code: code,
            id: id
        })

        await sendMail(Account.email, code)

        return res.status(200).json({
            message: 'Gửi thành công. Vui lòng kiểm tra email',
            data: {}
        })
    }
    catch(err)
    {
        console.log("Error at AccountController - Get Code: \n" + err);
        return res.status(500).json({
            status: "Get code reset failed",
            message: "Server đang bận. Vui lòng  thử lại sau!"
        })
    }

}

module.exports.ValidCode = async (req, res) =>{
    try{
        var Account = req.vars.User 
        let data  = {
            id: Account._id,
            user: Account.user,
            fullName: Account.fullName,            
            phone: Account.phone,
            email: Account.email,
            avt: Account.nameAvt,
        }

        await jwt.sign(data, SECRET_LOGIN, {expiresIn: "30m"}, (err, token)=>{
            if(err) throw err
          
            return res.status(200).json({
                message: 'Code đúng! Vui lòng nhập mật khẩu mới',
                data: {
                    token: token
                }
            })
        })
    }
    catch(err)
    {
        console.log("Error at AccountController - Login: ", err);
        return res.status(500).json({
            status: "Error Server When Login",
            message: "Server đang bận. Vui lòng  thử lại sau!"
        })
    }     

    
}


const createFolder = (root, idUser, nameAvt)=>
{
 
    const ROOT_AVT = root + "/public/account"

    let defaultAvt = `${ROOT_AVT}/default.png`
 
    let folderAccount = ROOT_AVT + "/" + idUser  

    let UserAvt = `${ROOT_AVT}/${idUser}/${nameAvt}`

    try
    {
        if (!fs.existsSync(folderAccount)) 
        {               
            fs.mkdirSync(folderAccount);   
        }

        if(!fs.existsSync(UserAvt) && fs.existsSync(defaultAvt))
        {
           // console.log("ok, ", UserAvt);
            fs.copyFileSync(defaultAvt, UserAvt)
        }
    }
    catch(err)
    {
        console.log("Error at AccounController - Create Folder Img For User: ", err);
        return false;
    }
    return true;
    // Kiểm tra xem tệp tin nguồn tồn tại hay không
}


const sendMail = async (email, code) =>
{
    

    const subject = "Reset Password";
    const html = `
    <p>Chao bạn ${email},</p>
    <p> Đây là mã để khôi phục mật khẩu của bạn <br> </p>
    <div style="display: flex; border: 1px solid black; padding: 10px; max-width: 130px; justify-content: center !important;">
        <h1 style="margin: 10px 33px;">${code}</h1> 
    </div> 
    <p><strong>Liên Kết sẽ hết hạn trong 5 phút, vui lòng khẩn trương ^^</strong><p>
    <p>Thank you</p>
    `;


    sendEmail(email, subject, html)
    
}
    