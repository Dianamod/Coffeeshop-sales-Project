import pandas as pd
import kaggle
from sqlalchemy import create_engine


# Authenticate with Kaggle
kaggle.api.authenticate()
kaggle.api.dataset_download_files(
    'tmthyjames/nashville-housing-data', path='.', unzip=True)

file_path = 'Nashville_housing_data_2013_2016.csv'
df = pd.read_csv(file_path)
print(df.head())

engine = create_engine(
    "mysql+mysqlconnector://root:Dianatsubera_1991!@localhost:3306/test")


file_path = 'Nashville_housing_data_2013_2016.csv'
df = pd.read_csv(file_path)

try:
    df.to_sql(name='Nashville_housing_data_2013_2016.csv', con=engine,
              if_exists='append', index=False)
    print('data inserted successful')
except Exception as e:
    print(f" error: {e}")
