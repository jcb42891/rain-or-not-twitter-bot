# Twitter Bot Instructions

## Overview

You are building a Twitter bot that will post a message to Twitter every day at 8 AM US Eastern Time. The content of the message will say whether or not it is raining in a randomly chosen US zip code. The bot will leverage the weatherapi API from https://www.weatherapi.com/ to check the weather in the user's area.

## Requirements

- The bot will post a message to Twitter every day at 8 AM US Eastern Time.
- Use Twitter API v2 for posting tweets
- Implement error handling and logging
- Store API credentials securely using environment variables
- Include retry logic for both Twitter and Weather API calls

## Implementation

- We will be using the weatherapi to get the weather information. Specifically we will be using the "Current Weather API" which can be found here: https://www.weatherapi.com/docs/current/
- We will be setting up a twitter developer account and creating an app to get the necessary credentials to post to twitter.
- We will be passing the twitter API KEY and Secret as environment variables to the bot.
- We will be passing the weather API key as an environment variable to the bot.
- The bot will pick a random latitude and longitude from cities.json which can be found in the root of the project.
- The bot will then use the weatherapi to get the weather information for the city and post a message to twitter with the weather information.
- We will use AWS eventbridge to schedule the bot to post at 8 AM US Eastern Time every day.


# Doc
We will be using the weatherapi to get the weather information. Specifically we will be using the "Current Weather API" which can be found here: https://www.weatherapi.com/docs/current/

The request will be made to the following endpoint:

```
https://api.weatherapi.com/v1/current.json?key=YOUR_API_KEY&q=
```

The response will be a json object with the weather information. Example response:

```
{
    "location": {
        "name": "Bloomsbury",
        "region": "New Jersey",
        "country": "USA",
        "lat": 40.6456,
        "lon": -75.0766,
        "tz_id": "America/New_York",
        "localtime_epoch": 1739726606,
        "localtime": "2025-02-16 12:23"
    },
    "current": {
        "last_updated_epoch": 1739726100,
        "last_updated": "2025-02-16 12:15",
        "temp_c": 1.7,
        "temp_f": 35.1,
        "is_day": 1,
        "condition": {
            "text": "Light rain",
            "icon": "//cdn.weatherapi.com/weather/64x64/day/296.png",
            "code": 1183
        },
        "wind_mph": 8.3,
        "wind_kph": 13.3,
        "wind_degree": 83,
        "wind_dir": "E",
        "pressure_mb": 992.0,
        "pressure_in": 29.28,
        "precip_mm": 0.0,
        "precip_in": 0.0,
        "humidity": 92,
        "cloud": 100,
        "feelslike_c": -2.0,
        "feelslike_f": 28.4,
        "windchill_c": -1.8,
        "windchill_f": 28.7,
        "heatindex_c": 1.4,
        "heatindex_f": 34.4,
        "dewpoint_c": 1.1,
        "dewpoint_f": 34.0,
        "vis_km": 3.2,
        "vis_miles": 1.0,
        "uv": 0.2,
        "gust_mph": 14.7,
        "gust_kph": 23.6
    }
}
```

## Example Tweet Format
"☔ It's raining in Springfield, MA today."
"☀️ It's not raining in Phoenix, AZ today."


# File Structure
rain-or-not-twitter-bot/
│── bot.py               # Main bot script
│── requirements.txt     # Dependencies (tweepy, dotenv, boto3)
│── config.env           # Environment variables (excluded in deployment)
│── deploy.sh            # Deployment script
│── eventbridge.json     # EventBridge rule for scheduling
│── README.md
└── .gitignore