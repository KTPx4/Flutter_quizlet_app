// Config library
const express = require('express')
const cors = require('cors')
require('dotenv').config()

//Call Router
const HomeRouter = require('./routes/HomeRouter')
const AccountRouter = require('./routes/AccountRouter')


// Define variable app
const _APP = express()
const _PORT = process.env.PORT || 3000
_APP.use(cors())


_APP.use('/', HomeRouter)
_APP.use('/account', AccountRouter)

_APP.use('*', (req, res)=>{
    res.json({
        code: 404,
        message: "The url not support"
    })
})
// Define Function
 
const startProgram = async()=>{
    // console.log(await bcrypt.hash("12345", 10));
    
    _APP.listen(_PORT, () => {
        console.log("App listen at: http://localhost:" + _PORT);
        })
    //  await require('./models/DB')
    //  .then(async()=>{
    //     //  console.log("Connect DB Success");   
    //  })    
    //  .catch((err)=>{
    //      console.log("Connect DB Failed: ", err);
    //  })
   
 }
 
 // Run Function 
 startProgram()


