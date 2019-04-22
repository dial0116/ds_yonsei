
# --------------------------------------------------------------------------------
# 다음 메인 페이지에서 실시간 검색어 수집 
#                               2017195151 윤정하
# --------------------------------------------------------------------------------

# 필요한 패키지를 불러옵니다. 
library(tidyverse)
library(httr)
library(rvest)


# 다음 실시간 검색어가 포함된 웹 페이지의 URI를 복사하여 붙입니다. 
'https://www.daum.net/'

# HTTP 요청을 실행합니다. 
res <- GET(url = 'https://www.daum.net/')

# 응답 결과를 확인합니다. 
print(x = res)


# 실시간 검색어를 추출합니다. 
searchWords <- res %>% 
  read_html() %>% 
  html_nodes(css = 'div.realtime_part > ol > li > div > div:nth-child(1) > span.txt_issue > a') %>% 
  html_text(trim = TRUE)

# 실시간 검색어를 출력합니다. 
print(x = searchWords)
s<-as.data.frame(searchWords)
colnames(s)<-c('검색어')
length(s['검색어'])
s<-cbind('순위'=rownames(s),s)

# 출력결과물을 저장합니다.
write.csv(s,'C:/Users/JunghaYun/Documents/데사입/다음실시간검색어.csv',row.names=F)


## End of Document
