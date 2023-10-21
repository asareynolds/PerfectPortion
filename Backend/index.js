const axios = require('axios');
const fs = require('fs');

const imgPath = '/usr/src/usr_images/20231001_133837.jpg';
const apiUserToken = '556010314da19ac112de88cb129b7a9476f32f59';
const headers = {
    'Authorization': 'Bearer ' + apiUserToken
};

// Single/Several Dishes Detection
const url1 = 'https://api.logmeal.es/v2/image/segmentation/complete';
axios.post(url1, fs.createReadStream(imgPath), {
    headers: {
        ...headers,
        'Content-Type': 'multipart/form-data'
    }
})
.then(response => {
    // Nutritional information
    const url2 = 'https://api.logmeal.es/v2/recipe/nutritionalInfo';
    return axios.post(url2, { imageId: response.data.imageId }, { headers: headers });
})
.then(response => {
    console.log(response.data); // display nutritional info
})
.catch(error => {
    console.error('Error:', error);
});