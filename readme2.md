##The Problem
College students are more nutritionally conscious than ever [CITATION_HERE], and studies show that keeping a record of meals is the best way to promote healthy eating [CITATION_HERE]. Despite this, current meal-tracking apps require users to enter food by hand. This process is time-consuming, and introduces unnecessary friction for users who simply want to better understand their health.

##The Solution
Perfect Portion is an app that automatically detects what food is present in a picture of a meal, listing key nutritional information and enabling users to make more informed choices about what they eat. A simple

##Our Technology
We used Swift UI to develop an Apple iOS application, and integrated this with a custom Node.JS backend running on a
multi-node Kubernetes cluster, with Oracle Cloud servers in US West and US East to ensure low latency. The backend interfaces with the LogMeal image segmentation machine learning service, which isolates and identifies speciific foods. Nutritional information is parsed, 

##Challenges and Solutions
This was the first hackathon for our backend developer - they had to adjust to the fast-paced environment of HackPSU.

##Accessibility
We followed ADA and WCAG guidelines for accessible interface design through the implementation of proper contrast, a structured content flow, large buttons and readable font, and additional whitespace padding. This helps all users use the app regardless of ability.

##Accomplishments that we’re proud of

##What we learned

##Operationalization
We plan to add more features and capabilities to our app, such as interfacing with the FDA FoodData database, allowing analysis of packaged food via barcode scanning, and deploying cross-platform to enable Android and web experiences.

##Open Source Code Used:
