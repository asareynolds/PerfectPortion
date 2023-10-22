# PerfectPortion
<img src="https://github.com/JMS1717/PerfectPortion/assets/43321848/bfa0c314-2d30-422d-97e8-64a801fe5fc7" width="500">



# 
A nutrition tracking app with an AI twist

## The Problem
Current weight tracking apps make it tedious to enter food information and difficult to capture everything. There’s currently no solution for people who want a convenient way to log their food. One study of nearly 1,700 participants found that keeping a food diary can double your weight loss when you're trying to shed unwanted pounds. According to a 2017 survey, only 26 percent of those aged 18 to 29 years regularly use apps to track their diet and nutrition.

## The Solution
Perfect Portion is an app that automatically detects what food is present in a picture of a meal, listing key nutritional information and enabling users to make more informed choices about what they eat. A simple

## Our Technology
We used Swift UI to develop an Apple iOS application, and integrated this with a custom Node.JS backend running on a multi-node Kubernetes cluster, with Oracle Cloud servers in US West and US East to ensure low latency. The backend interfaces with the LogMeal image segmentation machine learning service, which isolates and identifies specific foods. Nutritional information is parsed, and returned to the user in a simple, intuitive UI.

## Challenges and Solutions
This was the first hackathon for one of our team members- they had to adjust to the fast-paced, high-pressure environment of HackPSU. Another challenge we faced was that not all team members were familiar with GitHub. We adapted to this by having members with more experience help those with less, ensuring that everyone was able to collaborate and deploy code effectively,

## Accessibility
We followed ADA and WCAG guidelines for accessible interface design through the implementation of proper contrast, a structured content flow, large buttons and readable font, and additional whitespace padding. This helps all users use the app regardless of ability.

## Accomplishments that we’re proud of
We are incredibly proud about the technology stack we were able to create in under 24 hours. We were able to make a fully functioning image recognition pipeline that works for any picture without hardcoding anything. The accuracy of our results was much higher than we originally expected. 

## What we learned

## What's next for Perfect Portion
