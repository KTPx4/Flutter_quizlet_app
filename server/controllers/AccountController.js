const bcrypt = require('bcrypt')
const AccountModel = require('../models/AccountModel')
const fs = require('fs');

module.exports.Register = async (req, res) =>{
    let {email, user, password} = req.body
    let {root} = req.vars

    email = email.toLowerCase()
    try{
        bcrypt.hash(password, 10)
        .then(async(hashed) =>{
            const Account = await AccountModel.create({
                fullName: user,
                email: email,
                user: user,
                passWord: hashed
            })

            if(!createFolder(root, Account._id, Account.nameAvt))
                console.log(`Can't create folder for Account: '${Account._id}' - '${Account.user}'`);
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
        data: {}
    })
}

module.exports.Login = (req, res) =>{
    return res.status(200).json({
        message: 'Login Success',
        data: {}
    })
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