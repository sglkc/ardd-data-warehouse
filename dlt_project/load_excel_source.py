import os
from dotenv import load_dotenv
import dlt
from dlt.destinations import postgres
from dlt.sources.filesystem import filesystem

import utils

load_dotenv("../.env")

pg_host = os.getenv("POSTGRES_HOST", "")
pg_port = os.getenv("POSTGRES_PORT", "")
pg_user = os.getenv("POSTGRES_USER", "")
pg_password = os.getenv("POSTGRES_PASSWORD", "")
pg_database = os.getenv("POSTGRES_DB", "")
pg_connection = f"postgresql://{pg_user}:{pg_password}@{pg_host}:{pg_port}/{pg_database}?sslmode=disable"

def load_excel() -> None:
    source = filesystem(
        bucket_url="../sources",
        file_glob=f"bitre_fatalities_jun2025.xlsx",
    ) | utils.read_excel("BITRE_Fatality", header=4)

    pipeline = dlt.pipeline(
        pipeline_name=f"load_source_staging",
        destination=postgres(credentials=pg_connection),
        # schema name in pgsql to insert into
        dataset_name="bronze",
    )

    info = pipeline.run(source.with_name("fatalities"))

    print(f"load info:", info)
    print()

if __name__ == "__main__":
    load_excel()
