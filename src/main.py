
import os
import requests

API_URL = "https://api.football-data.org/v4/competitions/BL1"
API_TOKEN = os.getenv("FOOTBALL_DATA_API_TOKEN")

def get_bundesliga_data():
    if not API_TOKEN:
        raise ValueError("API token is missing!")

    headers = {
        "X-Auth-Token": API_TOKEN
    }

    response = requests.get(API_URL, headers=headers, timeout=30)
    response.raise_for_status()

    return response.json()


if __name__ == "__main__":
    data = get_bundesliga_data()

    print("API connection successful!")
    print("Competition:", data["name"])
    print("Country:", data["area"]["name"])
