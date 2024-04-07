const bcrypt = require('bcrypt')
const AccountModel = require('../models/AccountModel')
const fs = require('fs');
const jwt = require('jsonwebtoken')
const SECRET_LOGIN = process.env.KEY_SECRET_LOGIN || 'key-login'

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

    return res.status(200).json({
        message: 'Register Success',
        data: {
            account: account
        }
    })
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
            message: "Vui lòng đăng nhập lại",
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

module.exports.ChangePassword = (req, res) =>{
    return res.status(200).json({
        message: 'Change Password Success',
        data: {}
    })
}

module.exports.GetCodeReset = (req, res) =>{
    return res.status(200).json({
        message: 'GetCodeReset Success',
        data: {}
    })
}

module.exports.ResetPassword = (req, res) =>{
    return res.status(200).json({
        message: 'ResetPassword Success',
        data: {}
    })
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