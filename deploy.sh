#!/bin/bash

# Create deployment package
echo "Creating deployment package..."
pip install -r requirements.txt --target ./package
cd package
zip -r ../deployment.zip .
cd ..
zip -g deployment.zip bot.py
zip -g deployment.zip cities.json

# Deploy to AWS Lambda
echo "Deploying to AWS Lambda..."
aws lambda update-function-code \
    --function-name rain-or-not-twitter-bot \
    --zip-file fileb://deployment.zip

# Clean up
echo "Cleaning up..."
rm -rf package
rm deployment.zip

echo "Deployment complete!" 