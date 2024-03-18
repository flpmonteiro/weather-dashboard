import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """

    columns = [
        'station_id',
        'date',
        'element',
        'data_value',
        'm-flag',
        'q-flag',
        's-flag',
        'obs-time'
    ]

    dtypes = {
        'station_id': pd.StringDtype(),
        'date': pd.Int64Dtype(),
        'element': pd.StringDtype(),
        'data_value': pd.Int64Dtype(),
        'm-flag': pd.StringDtype(),
        'q-flag': pd.StringDtype(),
        's-flag': pd.StringDtype(),
        'obs-time': pd.Int64Dtype()
    }

    year = 2024
    url = f'https://www.ncei.noaa.gov/pub/data/ghcn/daily/by_year/{year}.csv.gz'

    df = pd.read_csv(
        url,
        sep=',',
        names=columns,
        compression='gzip',
        dtype=dtypes
    )

    df['date'] = pd.to_datetime(df['date'], format='%Y%m%d')

    return df

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
