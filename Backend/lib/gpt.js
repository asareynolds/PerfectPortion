
const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');
const { OpenAI } = require('openai');
require('dotenv').config();

const openai = new OpenAI({
  apiKey: process.env.GPT_KEY,
});

let APIcall = async (prompt) => { 
    return new Promise(async (resolve, reject) => {
        const chatCompletion = await openai.chat.completions.create({
            model: "gpt-3.5-turbo",
            messages: [{"role": "user", "content": prompt}],
        });
        console.log(chatCompletion.choices[0].message);
        resolve(chatCompletion.choices[0].message);
    });
}

const getRecommendations = async function(imageID, age, weight, gender,height,allergies) {
    const nutrients = JSON.parse(fs.readFileSync("/usr/src/usr_images/" + imageID + ".json", 'utf8'));
    var foodStrings = "";

    for (const property in nutrients) {
        food = nutrients[property];
        foodStrings += `${food.foodName} with a calorie count of ${Math.round(food.info.calories)} with ${Math.round(food.info.protein.quantity)}${food.info.protein.unit} of protein & ${Math.round(food.info.carb.quantity)}${food.info.carb.unit} of carbs & ${Math.round(food.info.fat.quantity)}${food.info.fat.unit} of fat, `;
    }
    var prompt = `This is a meal for a ${age}-year-old ${gender} who weighs ${weight} lbs and is ${height}inches tall. Meal: ${foodStrings}. Evaluate this meal from a nutritional perspective. Do not mention the prompt in the answer, simply give a succinct response, 1 to 2 sentences per point and never more than 2 sentences, discussing: 1. Nutritional Value 2. Recommendations for a better meal, including specific foods, or no recommendation if the meal is sufficient.`;
    console.log("Sending request to ChatGPT with prompt: " + prompt);
    var response = await APIcall(prompt);
    return response['content']
}

module.exports = {
    getRecommendations: getRecommendations
};