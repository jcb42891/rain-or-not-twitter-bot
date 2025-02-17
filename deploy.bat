@echo off
echo Creating deployment package...

:: Create and activate a temporary virtual environment
python -m venv venv
call venv\Scripts\activate

:: Create package directory and install dependencies
mkdir package
pip install -r requirements.txt --target ./package

:: Create deployment zip
cd package
powershell Compress-Archive -Path * -DestinationPath ..\deployment.zip -Force
cd ..

:: Add bot.py and cities.json to the zip
powershell Compress-Archive -Path bot.py, cities.json -DestinationPath deployment.zip -Update

:: Deploy to AWS Lambda
aws lambda update-function-code --function-name rain-or-not-twitter-bot --zip-file fileb://deployment.zip

:: Clean up
deactivate
rmdir /s /q package
rmdir /s /q venv
del deployment.zip

echo Deployment complete!
pause 