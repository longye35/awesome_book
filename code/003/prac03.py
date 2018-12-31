#%%
import numpy as np 
import pandas as pd 
df = pd.read_csv('data/reserve.csv', encoding = 'UTF-8')

#%%
# 集計処理を行う
#ホテルの別の予約数と顧客数を知りたい
#size関数とnunique関数で集計, agg関数で同時処理 

#%%
result = df.groupby('hotel_id') \
    .agg({'reserve_id':'size', 'customer_id':'nunique'})
result.reset_index(inplace = True)
result.columns = ['hotel_id', 'rsv_cnt', 'cus_cnt']

#%%
result.head(3)

#%%
result = df.groupby(['hotel_id', 'people_num'])['total_price'] \
    .sum().reset_index()
result.rename(columns = {'total_price':'eanring_sum'}, inplace=True)
#列名の書き換えが少ない時はrenameの方が便利

#%%
result.head(5)

#%%
#ホテル別宿泊金額の要約統計量
#aggの中にlambda式を入れて分位点も出せる
result = df.groupby('hotel_id')['total_price'] \
    .agg({'total_price':['min', 'max',
    'mean', 'median', lambda x: np.percentile(x, q=20)]}) \
    .reset_index() #np.quantileだとno moduleになる. なぜ？
result.columns = ['hotel_id','price_min', 'price_max', 'price_avg', 'price_median', 'price_20']

#%%
result.head()

#%%
#分散の計算
result = df.groupby('hotel_id')['total_price'] \
.agg({'total_price': ['var', 'std']}).reset_index()
result.columns = ['hotel_id', 'variance', 'st_deviation']
result.fillna(value = {'variance':0, 'st_deviation':0}, inplace = True)

#%%
result.head()

#%%
