# TODO: type kwargs better pls
from typing import Iterator
import pandas as pd
import dlt
from dlt.common.storages.fsspec_filesystem import FileItemDict
from dlt.common.typing import TDataItems


# Define a standalone transformer to read data from an Excel file.
@dlt.transformer
def read_excel(
    items: Iterator[FileItemDict],
    sheet_name: str,
    **kwargs,
) -> Iterator[TDataItems]:
    # Iterate through each file item.
    for file_obj in items:
        # Open the file object.
        with file_obj.open() as file:
            # Read from the Excel file and yield its content as dictionary records.
            yield pd.read_excel(file, sheet_name, **kwargs).to_dict(orient="records")
