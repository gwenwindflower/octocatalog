import modal

stub = modal.Stub(
    image=modal.Image.debian_slim().pip_install(["boto3", "requests"]),
)


@stub.function(secret=modal.Secret.from_name("winnie-aws"))
def scrape_data(active_datetime):
    from datetime import datetime

    import boto3
    import requests

    bucket_name = "github-archive-ddb"
    s3 = boto3.client("s3")

    url_datetime = datetime.strftime(active_datetime, "%Y-%m-%d-%-H")
    url = f"https://data.gharchive.org/{url_datetime}.json.gz"

    response = requests.get(url, stream=True)

    if response.status_code == 200:
        file_content = response.content
        s3.put_object(
            Bucket=bucket_name, Key=f"data/{url_datetime}.json.gz", Body=file_content
        )
    else:
        print(f"💩 Crap! {url_datetime} returned status code {response.status_code}.")


@stub.function()
def bucket_data(start, end):
    from datetime import datetime, timedelta

    start_datetime = datetime.strptime(start, "%Y-%m-%d-%H")
    end_datetime = datetime.strptime(end, "%Y-%m-%d-%H")
    active_datetime = start_datetime

    while active_datetime <= end_datetime:
        scrape_data.remote(active_datetime)
        active_datetime += timedelta(hours=1)


@stub.local_entrypoint()
def main(start, end):
    bucket_data.remote(start, end)
