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
    url = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt'
    response = requests.get(url)
    lines = response.text.splitlines()

    data = {
        'id': [],
        'latitude': [],
        'longitude': [],
        'elevation': [],
        'state': [],
        'name': [],
        'gsn_flag': [],
        'hcn_crn_flag': [],
        'wmo_id': []
    }
    # From documentation:
    # ID            1-11   Character
    # LATITUDE     13-20   Real
    # LONGITUDE    22-30   Real
    # ELEVATION    32-37   Real
    # STATE        39-40   Character
    # NAME         42-71   Character
    # GSN FLAG     73-75   Character
    # HCN/CRN FLAG 77-79   Character
    # WMO ID       81-85   Character
    for line in lines:
        data['id'].append(line[0:11].strip())
        data['latitude'].append(line[12:20].strip())
        data['longitude'].append(line[21:30].strip())
        data['elevation'].append(line[31:37].strip())
        data['state'].append(line[38:40].strip())
        data['name'].append(line[41:71].strip())
        data['gsn_flag'].append(line[72:75].strip())
        data['hcn_crn_flag'].append(line[76:79].strip())
        data['wmo_id'].append(line[80:85].strip())


    return pd.DataFrame(data)


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'