const express = require('express');
var bodyParser = require('body-parser');
const cors = require('cors');
var crypto = require("crypto");
const logmeal = require('./logmeal.js');

const app = express();
app.use(bodyParser.json())

app.use(cors());
app.listen(80, () => {
    console.log('Accepting requests on port 80');
});
app.set('trust proxy', true)

//Takes in images, saves image as file on server, and returns image id
app.post("/post/image",upload.single("file"), async(req, res) => {
    res.setHeader('Content-Type', 'application/json');
    const tempPath = req.file.path;
    const imageID = crypto.randomBytes(20).toString('hex');
    const targetPath = path.join(__dirname, "/usr/src/usr_images/" + imageID + ".jpg");

    if (path.extname(req.file.originalname).toLowerCase() === ".jpg") {
    fs.rename(tempPath, targetPath, err => {
        if (err) return handleError(err, res);

        res.status(200).end(`{"result": "success","imageId": "${imageID}"}`);
    });
    } else {
    fs.unlink(tempPath, err => {
        if (err) return handleError(err, res);

        res.status(403).end('{"error":"Only .png files are allowed!"}');
    });
    }
});
app.post('/get/nutrients', async(req, res) => {
    //const { user_username, user_email, user_pass, user_fname, user_lname } = req.body
    res.setHeader('Content-Type', 'application/json');
    var createUserResult = JSON.parse(await user.create(user_username, user_email, user_pass, user_fname, user_lname))
    if (createUserResult.result == "error") return res.end(`{"result": "error","type": "${createUserResult.type}"}`);
    email.sendVerification(createUserResult.uuid)
    var createTokenResult = JSON.parse(await token.generate("standard", createUserResult.uuid, client_id, client_ip))
    if (createTokenResult.result == "error") return res.end(`{"result": "error","type": "${createTokenResult.type}"}`);
    res.end(`{"result": "success","uuid": "${createUserResult.uuid}","token": "${createTokenResult.token}"}`);
});