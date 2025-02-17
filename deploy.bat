@echo off
echo Creating deployment package...

:: Create a temporary directory for the deployment package
mkdir deployment-package
cd deployment-package

:: Create and activate a virtual environment
python -m venv venv
call venv\Scripts\activate

:: Install dependencies
pip install -r ..\requirements.txt

:: Copy the dependencies to a lib folder
mkdir python
xcopy /E /H /C /I venv\Lib\site-packages\* python\

:: Copy your bot code
copy ..\bot.py python\
copy ..\cities.json python\

:: Create the deployment zip
powershell Compress-Archive -Path python\* -DestinationPath ..\deployment.zip -Force

:: Clean up
cd ..
rmdir /s /q deployment-package

:: Deploy to AWS Lambda
echo Deploying to AWS Lambda...
aws lambda update-function-code --function-name rain-or-not-twitter-bot --zip-file fileb://deployment.zip

echo Deployment complete!
pause 