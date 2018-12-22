setwd("/Users/mfjkou/sengokulab/study/awesomebook/")
install.packages("tidyverse")
library(tidyverse)

reserve_tb <- read.csv("data/reserve.csv", fileEncoding = "UTF-8",
                       header = TRUE, stringsAsFactors = FALSE)


#集計処理-カウント
#ホテル別の予約数と顧客数を知りたい
reserve_tb %>%
  group_by(hotel_id) %>%
  
  #summariseで集約処理を指定
  #n_functionでカウント処理, n_distinctでユニークに数え上げる
  summarise(rsv_cnt = n(),
            cus_cnt = n_distinct(customer_id))

#集計処理-合計
#宿泊人数別に売り上げ金額の合計を知りたい
reserve_tb %>%
  group_by(hotel_id, people_num) %>%
  summarise(earnings = sum(total_price)) %>%
  as.data.frame()

#集計処理-要約統計量
#ホテル別の金額の色々な情報を見たい
#quantile関数は下側分位点をとる
reserve_tb %>%
  group_by(hotel_id) %>%
  summarise(price_min = min(total_price),
            price_max = max(total_price), 
            price_avg = mean(total_price),
            price_median = median(total_price),
            price_20 = quantile(total_price, 0.2)) %>%
  as.data.frame()
  
#集計処理-分散と標準偏差
#ホテル別金額のばらつきを見る
#データ数1のときはNAになるのでこれを0とするのに注意

reserve_tb %>%
  group_by(hotel_id) %>%
  summarise(variance = coalesce(var(total_price), 0),
            st_deviation = coalesce(sd(total_price), 0)) %>%
  as.data.frame()
#別解
reserve_tb %>%
  group_by(hotel_id) %>%
  summarise(variance = var(total_price), st_deviation = sd(total_price)) %>%
  as.data.frame() %>%
  replace_na(list(variance=0, st_deviation = 0))
