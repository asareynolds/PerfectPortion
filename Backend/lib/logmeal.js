const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');

const getNutrients = async function(imageID) {
  var token = getRandomToken();
  console.log("Using Token: " + token)
  const imgPath = '/usr/src/usr_images/' + imageID + '.jpg';
  console.log("Using Image: " + imgPath)
  const imageLMID = await segmentateImage(token, imgPath)
    .catch(error => {
      console.log(error)
      return '{"error": "Failed to segmentate image"}'
    });
  const nutritionalInfoRaw = await getNutritionalInfo(token, imageLMID)
    .catch(error => {
      console.log(error)
      return '{"error": "Failed to obtain nutritional information"}'
    });
  //let nutritionalInfoRaw = JSON.parse(fs.readFileSync('response.json'));
  const nutritionalInfo = parseNutritionalInfo(nutritionalInfoRaw);
  fs.writeFile('/usr/src/usr_images/' + imageID + '.json', JSON.stringify(nutritionalInfo, null, 2), (error) => {if (error) {return;}});

  return nutritionalInfo;
}

//Parse raw data 
const parseNutritionalInfo = function(nutritionalInfoJSON) {
  foodItems = {};
  for (let i = 0; i < nutritionalInfoJSON.foodName.length; i++) {
    foodName = nutritionalInfoJSON.foodName[i];
    foodID = nutritionalInfoJSON.ids[i];
    if (!foodName.includes("chocolate")) {
      foodItems[foodID] = {"foodName": foodName, "foodID": foodID, "info": []};
    }
  }
  nutritionalInfoJSON.nutritional_info_per_item.forEach(item => {
    foodItems[item["id"]]["info"] = {
      "calories": item["nutritional_info"]["calories"],
      "protein": {
        "quantity": item["nutritional_info"]["totalNutrients"]["PROCNT"]["quantity"],
        "unit": item["nutritional_info"]["totalNutrients"]["PROCNT"]["unit"]
      },
      "carb": {
        "quantity": item["nutritional_info"]["totalNutrients"]["CHOCDF"]["quantity"],
        "unit": item["nutritional_info"]["totalNutrients"]["CHOCDF"]["unit"]
      },
      "fat": {
        "quantity": item["nutritional_info"]["totalNutrients"]["FAT"]["quantity"],
        "unit": item["nutritional_info"]["totalNutrients"]["FAT"]["unit"]
      }
    };
  }); 
  Object.keys(foodItems).forEach(item => {
    console.log(`{${item}: `)
    console.log(foodItems[item])
    console.log("}");
  })
  return foodItems;
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
        console.log(response.data.imageId)

        resolve(response.data.imageId);
      })
      .catch(error => {
        console.log("ERROR: " + authToken)
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
        resolve(response.data);
      })
      .catch(error => {
        console.error('Error:', error);
        reject(error);
      });
  });
}

//Get random token from tokens.json
const getRandomToken = function() {
  const tokens = require('../tokens.json').tokens;
  return tokens[Math.floor(Math.random() * tokens.length)];
}

module.exports = {
    getNutrients: getNutrients
};