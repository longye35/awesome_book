setwd("/Users/mfjkou/sengokulab/study/awesomebook/")
install.packages("tidyverse")
library(tidyverse)

reserve_tb <- read.csv("data/reserve.csv", fileEncoding = "UTF-8",
                       header = TRUE, stringsAsFactors = FALSE)
reserve_tb[, c("reserve_id", 'hotel_id', 'customer_id', 'reserve_datetime',
               'checkin_date', 'checkin_time', 'checkout_date')]
library(dplyr)
reserve_tb %>%
  #左辺を右辺に渡すという処理ができる
  select(reserve_id, hotel_id, customer_id, reserve_datetime, checkin_date,
         checkin_time, checkout_date) %>%
  as.data.frame() #dplyrのdataframe型からRのdataframe型へと変換する
#基本的に互換性あり(どこで互換性なくなる?)

#条件抽出:not awesome
reserve_tb[intersect(which(reserve_tb$checkin_date >= '2016-10-12'),
                     which(reserve_tb$checkin_date <= '2016-10-13')),]

reserve_tb %>%
  filter(checkin_date >= '2016-10-12' & checkin_date <= '2016-10-13')

#awesome
reserve_tb %>%
  filter(between(as.Date(checkin_date),
                 as.Date('2016-10-12'), as.Date('2016-10-13')))
#日付方への変換+between関数

#ランダムサンプリング
sample_frac(reserve_tb, 0.5)
sample_n(reserve_tb, 100)

#サンプリングの単位と分析したい絡むの単位を揃える
all_id <- unique(reserve_tb$customer_id)

reserve_tb %>%
  filter(customer_id %in% sample(all_id, size = length(all_id)*0.5))
