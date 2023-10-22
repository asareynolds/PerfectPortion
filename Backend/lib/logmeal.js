const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');

const apiUserToken = '556010314da19ac112de88cb129b7a9476f32f59';

const getNutrients = async function(imageID) {
  var token = apiUserToken;
  const imgPath = '/usr/src/usr_images/' + imageID + '.jpg';
  /*console.log(imgPath)
  const imageLMID = await segmentateImage(token, imgPath);
  console.log(imageLMID)
  const nutritionalInfoRaw = await getNutritionalInfo(token, imageLMID);*/

  let nutritionalInfoRaw = fs.readFileSync('response.json');
  console.log(nutritionalInfoRaw)
  //const parsedInfo 
}

//Parse raw data 
const parseNutritionalInfo = function(nutritionalInfoRaw) {
  
}

//LogMeal API Calls
const segmentateImage = async function(authToken, imgPath) { //TODO: COMPRESS IMAGES
  return new Promise((resolve, reject) => {
    const form = new FormData();
    form.append('image', fs.createReadStream(imgPath));

    const url = 'https://api.logmeal.es/v2/image/segmentation/complete';
    const headers = {
      'Authorization': 'Bearer ' + authToken,
      ...form.getHeaders() // Include the headers for the FormData
    };

    axios.post(url, form, { headers })
      .then(response => {
        console.log(response.data);
        console.log(response.data.imageId)

        resolve(response.data.imageId);
      })
      .catch(error => {
        console.error('Error:', error);
        reject(error);
      });
  });
}
const getNutritionalInfo = async function(authToken, imageID) {
  return new Promise((resolve, reject) => {
    const url = 'https://api.logmeal.es/v2/recipe/nutritionalInfo';
    const headers = {
      'Authorization': 'Bearer ' + authToken,
      'Content-Type': 'application/json'
    };

    axios.post(url, JSON.stringify({ imageId: imageID }), { headers: headers })
      .then(response => {
        console.log(response.data);
        resolve(response.data);
      })
      .catch(error => {
        console.error('Error:', error);
        reject(error);
      });
  });
}



/*
// Single/Several Dishes Detection
const url1 = 'https://api.logmeal.es/v2/image/segmentation/complete';
const url2 = 'https://api.logmeal.es/v2/recipe/nutritionalInfo';

//read file and convert to json
let rawdata = fs.readFileSync('response.json');


//THIS WORKS
/*axios.post(url1, form, { headers })
    .then(response => {
      console.log(response.data);
      console.log(response.data.imageId)
      // Nutritional information
      return axios.post(url2, JSON.stringify({ imageId: response.data.imageId }), { headers: headers2 })
    })
    .then(response => {
      console.log(response.data); // display nutritional info
    })
    .catch(error => {
      console.error('Error:', error);
    });*/

module.exports = {
    getNutrients: getNutrients
};