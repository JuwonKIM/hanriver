## 한강 이용현황 분석을 통한 R 연습과정
## Juwon KIM 


# install packages ===============================================

# check if ggplot2, dplyr are already installed
installed_packages <- row.names(installed.packages())
if (!('dplyr' %in% installed_packages)) install.packages('dplyr')
if (!('ggplot2' %in% installed_packages)) install.packages('ggplot2')


# load packages ==================================================

library(dplyr)
library(ggplot2)


# read data ======================================================

# check working directory
getwd()
# 2015-05-21 워킹 디렉토리를 항상 먼저 체크해야 하는가?
# 2015-05-22 작업 파일들이 있는 폴더만 인지하고 있으면 굳이 체크할 필요는 없음

h <- read.csv(file='./2014_Jan_Oct_HanRiver_User.csv')
# 2015-05-21 read.csv 함수안에 데이터 파일명 입력 시 [file=' ']을 붙이지 않으니 실행이 안됨
# 2015-05-22 [file=' '] 전체를 붙일 필요는 없고 파일명 처음과 끝에 [' ']을 붙이면 됨

head(h)
# 2015-05-22 head는 상위의 일부 데이터를 보여줌 (cf. head(hanriver,10) => 경우 상위 10개)
str(h)
# 2015-05-22 str는 column 별 데이터 속성값을 행으로 보여줌 (예. int, factor)
tail(h)
# 2015-05-22 tail은 하위의 일부 데이터를 보여줌
class(h)
# 2015-05-22 class는 파일의 형태를 알려주는듯? (예. "data.frame")


# draw ===========================================================

ggplot(h , aes(x = area, y = BCYCL)) +
  geom_point()
# 2015-05-22 geom_point에서 여의도 데이터 중 혼자 튀는 녀석을 제외시키기 위해 범위를 설정해야 할듯 
# 2015-05-22 중복되는 데이터가 있어 분석을 위해서는 재가공이 필요함(month, area)             

ggplot(h , aes(x = area, y = BCYCL)) +
  geom_boxplot() +
  theme_bw()
# 2015-05-27 기타 다양한 그래프는 <http://docs.ggplot2.org/current/> 사이트 참조




## Date : 2015.05.27 


# check data file ================================================

datapath <- 'D:/Rstudy/hanriver'
list.files(path = datapath, pattern = '*.csv')


# read data ======================================================

h <- read.csv(file='./2014_Jan_Oct_HanRiver_User.csv')


# Starting dplyr::tbl_df =========================================

h <- tbl_df(h)
h

str(h)

# dplyr : 데이터를 변환할 수 있는 패키지 =========================
# dplyr 참고 사이트 <http://blog.daum.net/_blog/BlogTypeView.do?blogid=0QoPO&articleno=269&categoryId=8&regdt=20140923103928>

# dplyr::filter : 데이터 필터링

?dplyr::filter

filter(h, month == 5)
  # 특정값을 가지고 있는 행만 필터링

filter(h, BCYCL > 300000)
  # 특정값 이상의 값을 가지고 있는 행만 필터링

filter(h, month %in% c(5, 6))
  # 두개의 특정값을 가지고 있는 행만 필터링

filter(h, month == 5 | 6)
  # 정확한 의미 확인 필요?????

filter(h, month != 1)
  # 특정값을 가진 행만 제외

filter(h, EVENT_MARATHON > BCYCL)
  # 특정 범위값 필터링


# dplyr:select : 특정 데이터만 추출

select(h, c(month, area, BCYCL, EVENT_MARATHON))
  # 원하는 column만 추출

select(h, -area)
  #해당 column 제외


## Date : 2015.05.28 


# dplyr::arrange : sorting 하기

arrange(h, BCYCL)
# BCYCL을 기준으로 오름차순으로 정렬

arrange(h, desc(BCYCL))
# BCYCL을 기준으로 내림차순으로 정렬

arrange(h, desc(EVENT_MARATHON, BCYCL))
# EVENT_MARATHON을 1차, BCYCL을 2차 기준으로 하여 내림차순으로 정렬




# 한강 데이터 변환 ===============================================

# 1. 지역별(area) all 데이터
# 엑셀로 .csv 파일을 열어 messy data를 tidy data로 변환 => 간편하게 할 수 없을까?

ttukseom <- read.csv('./hanriver_user_ttukseom.csv')
ttukseom

str(ttukseom)

ggplot(ttukseom, aes(x=month, y=act_count)) +
  geom_line(aes(color = activity))

ggplot(ttukseom, aes(x=activity, y=act_count)) +
  geom_boxplot() +
  theme_bw()



## Date : 2015.06.04 


# five-number summary ============================================

gn <- h$GNRL
sp <- h$SPORTS_FCLTY
bc <- h$BCYCL
ev <- h$EVENT_MARATHON
pa <- h$SPCLIZ_PARK
et <- h$ETC

fivenum(gn)
fivenum(sp)
fivenum(bc)

summary(h)


ac <- ttukseom$activity
co <- ttukseom$act_count

fivenum(co)

summary(ttukseom)



## Date : 2015.06.11 


# draw boxplot using loop ========================================

y.names <- names(h)[3:8]
for (y.name in y.names) {
  p <- ggplot(h, aes_string(x='area', y=y.name)) +
    geom_boxplot() +
    theme_bw() +
    ggtitle(paste('Box plot for', y.names))
  ggsave(p, filename=paste0('hanriver_boxplot_', y.name, '.png'))
}
# Y축 항목만 바꾸고 여러개의 그림을 한번에 그리기
# 상기와 같은 과정을 수행하기 위해서는 데이터 테이블구조가 중요하며 각 속성을 열로 구분하는 것이 좋음
# ttukseom 데이터 구조는 바람직하지 않음
