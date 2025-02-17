@echo off
echo Creating EventBridge rule...

:: Get the Lambda function ARN
for /f "tokens=* USEBACKQ" %%F in (`aws lambda get-function --function-name rain-or-not-twitter-bot --query Configuration.FunctionArn --output text`) do (
    set LAMBDA_ARN=%%F
)

:: Create the EventBridge rule
aws events put-rule ^
    --name RainOrNotTwitterBotSchedule ^
    --schedule-expression "cron(0 12 * * ? *)" ^
    --description "Triggers the Rain-or-Not Twitter bot daily at 8 AM EST (12 PM UTC)" ^
    --state ENABLED

:: Add permission for EventBridge to invoke Lambda
aws lambda add-permission ^
    --function-name rain-or-not-twitter-bot ^
    --statement-id EventBridgeInvoke ^
    --action lambda:InvokeFunction ^
    --principal events.amazonaws.com ^
    --source-arn arn:aws:events:us-east-1:933924041275:rule/RainOrNotTwitterBotSchedule

:: Add the Lambda function as a target for the rule
aws events put-targets ^
    --rule RainOrNotTwitterBotSchedule ^
    --targets "Id"="1","Arn"="%LAMBDA_ARN%"

echo EventBridge rule created successfully!
pause 