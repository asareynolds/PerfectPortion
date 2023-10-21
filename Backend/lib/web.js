const express = require('express');
var bodyParser = require('body-parser');
const multer = require("multer");
const cors = require('cors');
var crypto = require("crypto");
const fs = require("fs");
const logmeal = require('./logmeal.js');

const app = express();
app.use(bodyParser.json())

app.use(cors());
app.listen(80, () => {
    console.log('Accepting requests on port 80');
});
app.set('trust proxy', true)

//Takes in images, saves image as file on server, and returns image id
//Returns: {"result": "success","imageId": "8360fa57458e5f9a07564f96b9d51f792c004aee"}
const upload = multer({ dest: '/usr/src/usr_images/tmp' });

app.post("/post/image", upload.single('image'), async(req, res) => {
    res.setHeader('Content-Type', 'application/json');
    if (!req.file) {
        return res.status(400).send('No files were uploaded.');
    }

    console.log(req.file.path)

    const imageID = crypto.randomBytes(20).toString('hex');
    const targetPath = "/usr/src/usr_images/" + imageID + ".jpg";

    // Renaming the file
    fs.rename(req.file.path, targetPath, err => {
        if (err) return res.status(500).send('Error uploading file');
        res.status(200).end(`{"result": "success","imageId": "${imageID}"}`);
    });
});
//Takes in imageID, returns nutritional information
app.get('/get/nutrients', async(req, res) => {
    const imageID = req.query.imageID
    res.setHeader('Content-Type', 'application/json');
    logmeal.getNutrients(imageID).then((nutrients) => {
        res.status(200).end(nutrients);
    });
    //res.end(`{"result": "success","uuid": "${createUserResult.uuid}","token": "${createTokenResult.token}"}`);
});