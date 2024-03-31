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
    url = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-countries.txt'
    response = requests.get(url)
    content = response.text
    lines = content.splitlines()

    data = {
        'code': [],
        'country': []
    }

    for line in lines:
        code, country = line[:2], line[3:].strip()
        data['code'].append(code)
        data['country'].append(country)

    df = pd.DataFrame(data)

    return df

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
