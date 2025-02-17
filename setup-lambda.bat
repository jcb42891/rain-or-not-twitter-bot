@echo off
echo Creating AWS Lambda function...

:: Create IAM role for Lambda
aws iam create-role ^
    --role-name rain-or-not-twitter-bot-role ^
    --assume-role-policy-document "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"

:: Attach basic Lambda execution policy
aws iam attach-role-policy ^
    --role-name rain-or-not-twitter-bot-role ^
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

:: Wait for role to be ready
timeout /t 10

:: Get the role ARN
for /f "tokens=* USEBACKQ" %%F in (`aws iam get-role --role-name rain-or-not-twitter-bot-role --query Role.Arn --output text`) do (
    set ROLE_ARN=%%F
)

:: Create Lambda function
aws lambda create-function ^
    --function-name rain-or-not-twitter-bot ^
    --runtime python3.9 ^
    --handler bot.main ^
    --role %ROLE_ARN% ^
    --timeout 30 ^
    --memory-size 128 ^
    --zip-file fileb://dummy.zip

echo Lambda function created successfully!
pause 