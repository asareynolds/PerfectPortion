const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');

const imgPath = '/usr/src/usr_images/20231001_133837.jpg';
const apiUserToken = '556010314da19ac112de88cb129b7a9476f32f59';

const form = new FormData();
form.append('image', fs.createReadStream(imgPath));

const headers = {
    'Authorization': 'Bearer ' + apiUserToken,
    ...form.getHeaders() // Include the headers for the FormData
};
const headers2 = {
    'Authorization': 'Bearer ' + apiUserToken,
    'Content-Type': 'application/json'
};

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




/*axios.post(url2, json, { headers: headers2 })
  .then(response => {
    console.log(response.data); // display nutritional info
    fs.writeFile('response.json', JSON.stringify(response.data), function (err) {
      if (err) {
        console.error('Error writing to file:', err);
      } else {
        console.log('Response data has been written to file successfully.');
      }
    });
  })
  .catch(error => {
    console.log(error);
  });*/
/*
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
*/