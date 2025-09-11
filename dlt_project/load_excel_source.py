from collections.abc import Iterator
import os

from dotenv import load_dotenv
import dlt
from dlt.common.storages.fsspec_filesystem import FileItemDict
from dlt.common.typing import TDataItems
from dlt.destinations import postgres
from dlt.sources.filesystem import filesystem

load_dotenv("../.env")

pg_host = os.getenv("POSTGRES_HOST", "")
pg_port = os.getenv("POSTGRES_PORT", "")
pg_user = os.getenv("POSTGRES_USER", "")
pg_password = os.getenv("POSTGRES_PASSWORD", "")
pg_database = os.getenv("POSTGRES_DATABASE", "")
pg_connection = f"postgresql://{pg_user}:{pg_password}@{pg_host}:{pg_port}/{pg_database}?sslmode=disable"

# Define a standalone transformer to read data from an Excel file.
# TODO: type kwargs better pls
@dlt.transformer
def read_excel(
    items: Iterator[FileItemDict],
    sheet_name: str,
    **kwargs,
) -> Iterator[TDataItems]:
    # Import the required pandas library.
    import pandas as pd

    # Iterate through each file item.
    for file_obj in items:
        # Open the file object.
        with file_obj.open() as file:
            # Read from the Excel file and yield its content as dictionary records.
            yield pd.read_excel(file, sheet_name, **kwargs).to_dict(orient="records")

def load_excel() -> None:
    source = filesystem(
        bucket_url="../sources",
        file_glob=f"bitre_fatalities_jun2025.xlsx",
    ) | read_excel("BITRE_Fatality", header=4)

    _ = source.apply_hints(
            # https://dlthub.com/docs/general-usage/incremental-loading
            # use "merge" to update existing data and add new data without truncating
            write_disposition="merge",
            primary_key="crash_id",
        )

    pipeline = dlt.pipeline(
        pipeline_name=f"load_source_staging",
        destination=postgres(credentials=pg_connection),
        # schema name in pgsql to insert into
        dataset_name="staging",
    )

    info = pipeline.run(source.with_name("fatalities"))

    print(f"load info:", info)
    print()

if __name__ == "__main__":
    load_excel()
