import argparse
import os
import requests
import duckdb
import time
from tqdm import tqdm
import argparse
from datetime import datetime, date, timedelta

def validate_date(date_str):
    try:
        input_date = datetime.strptime(date_str, "%Y-%m-%d").date()
        current_date = date.today()
        if input_date < date(2023, 1, 1) or input_date > current_date:
            raise argparse.ArgumentTypeError(f"Date {date_str} is outside the acceptable range.")
        return input_date
    except ValueError:
        raise argparse.ArgumentTypeError(f"Invalid date format: {date_str}. Please use the format YYYY-MM-DD.")


def load_data(dir_path):
    # print(f'🦆 Loading data from {dir_path} into DuckDB...')
    con = duckdb.connect(database="github_archive.db", read_only=False)

    files = os.listdir(dir_path)

    # for index, file in tqdm(enumerate(files), total=len(files)):
        # file_path = os.path.join(dir_path, file)

    # con.execute("CREATE OR REPLACE TABLE github_events(id STRING, type STRING, actor MAP(STRING, STRING), repository MAP(STRING, STRING), payload MAP(STRING, STRING), public BOOLEAN, created_at TIMESTAMP, org MAP(STRING, STRING));")
    # print('created table')
        # if index == 0:
        #     con.execute(f"CREATE OR REPLACE TABLE github_events AS SELECT * FROM './data/2023-08-16-0.json.gz';")
        # else:
        #     print('woo')
    # print('now loading')
    # con.execute("CREATE OR REPLACE TABLE github_events(id STRING, type STRING, actor MAP(STRING, STRING), repository MAP(STRING, STRING), payload MAP(STRING, STRING), public BOOLEAN, created_at TIMESTAMP, org MAP(STRING, STRING)); COPY github_events FROM './data/2023-08-16-0.json';")

def download_data(active_datetime):
    url_datetime = datetime.strftime(active_datetime, "%Y-%m-%d-%-H")
    url = f'https://data.gharchive.org/{url_datetime}.json.gz'

    file_path = f'./data/{url_datetime}.json.gz'

    if not os.path.exists(file_path):
        response = requests.get(url, stream=True)
        total_size_in_bytes= int(response.headers.get('content-length', 0))
        progress_bar = tqdm(total=total_size_in_bytes, unit='kB', unit_scale=True, leave=False, desc=f'💾 Downloading data from Github Archive for {active_datetime}...')

        if response.status_code == 200:
            with open(file_path, "wb") as output_file:
                for chunk in response.iter_content(chunk_size=1024):
                    output_file.write(chunk)
                    progress_bar.update(len(chunk))
            progress_bar.close()
        else:
            print(f"💩 Crap! {url_datetime} returned status code {response.status_code}.")
#
# parser = argparse.ArgumentParser()
# # TODO Allow hourly granularity
# parser.add_argument("start_date", help="The start date of the range", default=str(date.today() - timedelta(days=1)) , nargs='?', type=validate_date)
# parser.add_argument("end_date", help="The end date of the range", default=str(date.today()), nargs='?', type=validate_date)
# args = parser.parse_args()
#
# start_datetime = datetime.combine(args.start_date, datetime.min.time())
# end_datetime = datetime.combine(args.end_date, datetime.min.time())
#
# total_hours = int((end_datetime - start_datetime).total_seconds() / 3600)
# # progress_bar = tqdm(total=total_hours)
#
# active_datetime = start_datetime
# #
# while active_datetime <= end_datetime:
#     download_data(active_datetime)
#     progress_bar.update(1)  # Increment the progress bar
#     active_datetime += timedelta(hours=1)
#
# progress_bar.close()

# load_data('./data')





# THIS IS ALL THAT IS HAPPENING

con = duckdb.connect(database="github_archive.db", read_only=False)
# con.execute("CREATE OR REPLACE TABLE github_events(id STRING, type STRING, actor JSON, repository JSON, payload JSON, public BOOLEAN, created_at TIMESTAMP, org JSON); COPY github_events FROM './sample-data/2015-01-01-15.json';")
# i think some fields have changed names maybe? repo -> repository....org exists on some events and not others...so perhaps slurping it up as one row then breaking it out is necessary?
con.execute("CREATE OR REPLACE TABLE github_events(id STRING, type STRING, actor MAP(STRING, STRING), repository MAP(STRING, STRING), payload MAP(STRING, STRING), public BOOLEAN, created_at TIMESTAMP, org MAP(STRING, STRING)); COPY github_events FROM './sample-data/2015-01-01-15.json';")
# con.execute("CREATE OR REPLACE TABLE github_events(event JSON); COPY github_events FROM './sample-data/2015-01-01-15.json';")
