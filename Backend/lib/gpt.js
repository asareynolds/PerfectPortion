const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');

const getRecommendations = async function(imageID) {
    var nutrients = JSON.parse(fs.readFileSync("/usr/src/usr_images/" + imageID + ".json", 'utf8'));
    
    
    return JSON.stringify(nutrients)
}
module.exports = {
    getRecommendations: getRecommendations
};