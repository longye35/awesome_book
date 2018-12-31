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


#集計処理-最頻値を発見する
#1000単位で四捨五入したあとに集計する-table関数
#カテゴリ別のカウントが最大であるものを見つける
#which.maxで最大値をもつベクトル情報を抽出し、namesで属性情報抽出
names(which.max(table(round(reserve_tb$total_price, -3))))


#集計処理-順序付
#比較のために時間型データに変換してからwindow関数を使う
reserve_tb$reserve_datetime <- as.POSIXct(reserve_tb$reserve_datetime, format = '%Y-%m-%d %H:%M:%S')

reserve_tb %>%
  group_by(customer_id) %>%
  mutate(log_no = row_number(reserve_datetime)) %>%
  as.data.frame()

#ホテルごとの予約数を出して, その予約数で順位付する

reserve_tb %>%
  group_by(hotel_id) %>%
  summarise(rsv_cnt = n()) %>%
  #予約回数をもとに順位を算出する
  #同じランクなら最小順位を全てつけてあげる->min_rank + descで降順
  #transmuteで指定した列のみ残す
  transmute(hotel_id, rsv_cnt_rank = min_rank(desc(rsv_cnt))) %>%
  as.data.frame()

