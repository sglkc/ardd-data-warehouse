import os
import sys
from dotenv import load_dotenv
import dlt
from dlt.destinations import postgres
from dlt.sources.filesystem import filesystem, read_csv

import utils

load_dotenv("../.env")

pg_host = os.getenv("POSTGRES_HOST", "")
pg_port = os.getenv("POSTGRES_PORT", "")
pg_user = os.getenv("POSTGRES_USER", "")
pg_password = os.getenv("POSTGRES_PASSWORD", "")
pg_database = os.getenv("POSTGRES_DB", "")
pg_connection = f"postgresql://{pg_user}:{pg_password}@{pg_host}:{pg_port}/{pg_database}?sslmode=disable"

from typing import NotRequired, TypedDict, Dict, Any

class ExcelConfig(TypedDict):
    sheet: str
    kwargs: Dict[str, Any]

class SourceConfig(TypedDict):
    filename: str
    table: str
    excel: NotRequired[ExcelConfig]

sources: Dict[str, SourceConfig] = {
    "fatalities-jun": {
        "filename": "bitre_fatalities_jun2025.xlsx",
        "table": "fatalities",
        "excel": {
            "sheet": "BITRE_Fatality",
            "kwargs": {
                "header": 4
            }
        }
    },
    "fatalities-jul": {
        "filename": "bitre_fatalities_jul2025.xlsx",
        "table": "fatalities",
        "excel": {
            "sheet": "BITRE_Fatality",
            "kwargs": {
                "header": 4
            }
        }
    },
    "lga": {
        "filename": "CG_LGA_2020_LGA_2021.csv",
        "table": "local_government_areas",
    },
    "ra": {
        "filename": "CG_RA_2016_RA_2021_GRID16.csv",
        "table": "remoteness_areas",
    },
    "sa4": {
        "filename": "CG_SA4_2016_SA4_2021.csv",
        "table": "statistical_areas_level_4",
    },
}

def load_fatalities(name: str, data: SourceConfig) -> None:
    print(f"parsing {name} from {data['filename']}...")

    read_func = read_csv

    if "excel" in data:
        read_func = utils.read_excel(data['excel']['sheet'], **data['excel']['kwargs'])

    source = filesystem(
        bucket_url="../sources",
        file_glob=data['filename'],
    ) | read_func

    pipeline = dlt.pipeline(
        pipeline_name=f"load_{data['table']}_bronze",
        destination=postgres(credentials=pg_connection),
        # schema name in pgsql to insert into
        dataset_name="bronze",
    )

    info = pipeline.run(source.with_name(data['table']))

    print(f"{name} -> {data['table']} load info:")
    print(info)
    print()

def run():
    source = sys.argv[1] if len(sys.argv) > 1 else ""
    data = sources.get(source)

    if not data:
        keys = list(sources.keys())

        if source == "all":
            for key in keys:
                load_fatalities(key, sources[key])
            return

        keys.insert(0, "all")
        print(f"Unknown source: {source}")
        print(f"Available sources: {keys}")
        sys.exit(1)

    load_fatalities(source, data)
    return

if __name__ == "__main__":
    run()
