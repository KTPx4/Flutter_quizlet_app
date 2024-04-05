const mongoose = require('mongoose')

// const serverDB = process.env.SERVER_DB || "mongodb://127.0.0.1:27017"
// const dbName = process.env.DBNAME || "Quizlet"

// const uri = `${serverDB}/${dbName}`

const User = process.env.UserDB || "FlutterQuizlet"
const Password = process.env.PassDB || "Flutter123"
const Area = process.env.AreaDB || "dbfinal.th4yvbk.mongodb.net"
const dbName = process.env.NameDB || "Quizlet"

const uri = `mongodb+srv://${User}:${Password}@${Area}/${dbName}`




module.exports = mongoose.connect(uri)