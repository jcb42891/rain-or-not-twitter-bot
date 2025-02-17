@echo off
echo Updating Lambda handler...

aws lambda update-function-configuration ^
    --function-name rain-or-not-twitter-bot ^
    --handler bot.lambda_handler

echo Lambda handler updated successfully!
pause 