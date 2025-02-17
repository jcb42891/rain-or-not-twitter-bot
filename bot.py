import os
import json
import random
import logging
import requests
from datetime import datetime
from dotenv import load_dotenv
import tweepy
from time import sleep

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv('config.env')

# API credentials
TWITTER_API_KEY = os.getenv('TWITTER_API_KEY')
TWITTER_API_SECRET = os.getenv('TWITTER_API_SECRET')
TWITTER_ACCESS_TOKEN = os.getenv('TWITTER_ACCESS_TOKEN')
TWITTER_ACCESS_TOKEN_SECRET = os.getenv('TWITTER_ACCESS_TOKEN_SECRET')
WEATHER_API_KEY = os.getenv('WEATHER_API_KEY')

def get_random_city():
    """Load and return a random city from cities.json"""
    try:
        with open('cities.json', 'r') as f:
            cities = json.load(f)
            return random.choice(cities)
    except Exception as e:
        logger.error(f"Error loading cities.json: {str(e)}")
        raise

def get_weather(lat, lon, max_retries=3):
    """Get weather data for given coordinates with retry logic"""
    url = f"https://api.weatherapi.com/v1/current.json?key={WEATHER_API_KEY}&q={lat},{lon}"
    
    for attempt in range(max_retries):
        try:
            response = requests.get(url)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            if attempt == max_retries - 1:
                logger.error(f"Failed to get weather data after {max_retries} attempts: {str(e)}")
                raise
            sleep(2 ** attempt)  # Exponential backoff

def post_tweet(message, max_retries=3):
    """Post tweet with retry logic"""
    client = tweepy.Client(
        consumer_key=TWITTER_API_KEY,
        consumer_secret=TWITTER_API_SECRET,
        access_token=TWITTER_ACCESS_TOKEN,
        access_token_secret=TWITTER_ACCESS_TOKEN_SECRET
    )
    
    for attempt in range(max_retries):
        try:
            response = client.create_tweet(text=message)
            logger.info(f"Tweet posted successfully: {message}")
            return response
        except Exception as e:
            if attempt == max_retries - 1:
                logger.error(f"Failed to post tweet after {max_retries} attempts: {str(e)}")
                raise
            sleep(2 ** attempt)  # Exponential backoff

def main():
    try:
        # Get random city
        city = get_random_city()
        
        # Get weather data
        weather_data = get_weather(city['latitude'], city['longitude'])
        
        # Check if it's raining
        condition = weather_data['current']['condition']['text'].lower()
        is_raining = any(word in condition for word in ['rain', 'drizzle', 'shower'])
        
        # Format location
        location = f"{weather_data['location']['name']}, {weather_data['location']['region']}"
        
        # Create tweet message with website link
        message = f"{'☔' if is_raining else '☀️'} It's {'' if is_raining else 'not '}raining in {location} today.\n\nrainornot.com will tell you if it's raining in your area.\n\n Or if it's not."
        
        # Post tweet
        post_tweet(message)
        
    except Exception as e:
        logger.error(f"Bot execution failed: {str(e)}")
        raise

if __name__ == "__main__":
    main() 