#%%
import numpy as np 
import pandas as pd
#%%
!pwd

#%%
df = pd.read_csv('data/reserve.csv', encoding = 'UTF-8')

#%%
df[["reserve_id", 'hotel_id', 'customer_id', 'reserve_datetime',
               'checkin_date', 'checkin_time', 'checkout_date']]

#%%
df.loc[:, ["reserve_id", 'hotel_id', 'customer_id', 'reserve_datetime',
               'checkin_date', 'checkin_time', 'checkout_date']]

#%%
df.query('"2016-10-12" <=checkin_date <= "2016-10-13"')

#%%
df.sample(frac = 0.5)

#%%
df.sample(n=100)

#%%
target = pd.Series(df['customer_id'].unique()).sample(frac=0.5)
df[df['customer_id'].isin(target)]


#%%
