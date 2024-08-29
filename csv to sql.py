import pandas as pd
import kaggle
from sqlalchemy import create_engine


# Authenticate with Kaggle
kaggle.api.authenticate()
kaggle.api.dataset_download_files(
    'ahmedabbas757/coffee-sales', path='.', unzip=True)

file_path = 'Coffee Shop Sales.csv'
df = pd.read_csv(file_path)
print(df.head())

engine = create_engine(
    "mysql+mysqlconnector://root:---!@localhost:---")


file_path = 'Coffee Shop Sales.csv'
df = pd.read_csv(file_path)

try:
    df.to_sql(name='Coffee Shop Sales.csv', con=engine,
              if_exists='append', index=False)
    print('data inserted successful')
except Exception as e:
    print(f" error: {e}")
