
# --------------------------------------------------------------------------------
# 네이버 증권 KOSPI 데이터 수집 
#                       2017195151 윤정하
# --------------------------------------------------------------------------------

#install.packages('urltools')
# 필요한 패키지를 불러옵니다. 
library(httr)
library(urltools)
library(rvest)
library(tidyverse)

# URI를 복사하여 붙입니다. 
'https://finance.naver.com/sise/sise_index.nhn?code=KOSPI'

# HTTP 요청을 실행합니다.
res <- GET(url = 'https://finance.naver.com/sise/sise_index.nhn', 
           query = list(code='KOSPI'))

# 응답 결과를 확인합니다. 
print(x = res)

# 요청 항목을 확인합니다. 
print(x = res$request)


# --------------------------------------------------------------------------------

# 이제 정상적으로 HTTP 요청이 이루어졌으니 데이터를 수집합니다. 
# 확인매물 데이터는 <table> 태그에 포함되어 있습니다. 
# html_table() 함수를 사용하면 쉽게 수집할 수 있다는 것, 아시죠? 

# CSS selector는 크롬 개발자도구에서 복사한 것을 사용합니다. 

# Windows 사용자만 로케일을 임시로 변경합니다. 
Sys.setlocale(category = 'LC_ALL', locale = 'C')

# 확인매물 데이터가 들어있으므로 tbl 객체에 할당하고 전처리하겠습니다. 
# CSS selector이 필요 이상으로 길기 때문에 아래와 같이 줄이겠습니다.
tbl <- res %>% 
  read_html(encoding='EUC-KR') %>% 
  html_node(css = 'table.table_kos_index') %>% 
  html_table(fill = TRUE)


# Windows 사용자만 로케일을 원복합니다.
Sys.setlocale(category = 'LC_ALL', locale = 'korean')


# tbl 객체를 미리보기 합니다. 
glimpse(x = tbl)


# --------------------------------------------------------------------------------
# 데이터 전처리 
# --------------------------------------------------------------------------------

# tbl을 확인합니다. 
print(x = tbl)
str(tbl)
tbl1<-t(tbl[,1:2])
tbl2<-t(tbl[,3:4])
rownames(tbl1)<-NULL
rownames(tbl2)<-NULL
#tbl1
#tbl2
tbl_new<-cbind(tbl1,tbl2)
tbl_new<-tbl_new[,-8]
tbl_new<-tbl_new[,c(1,5,2,6,3,7,4)]

# tbl 객체를 미리보기 합니다. 
glimpse(x = tbl)

tbl_new[,7]<-tbl_new[,7] %>% str_remove_all(pattern ='\n|\t| ')
#tbl_new

# tbl 객체를 새 창에서 엽니다. 
View(x = tbl_new)

# tbl 객체를 저장합니다.
write.table(tbl_new,'C:/ds_yonsei/homework/naver_KOSPI_list.csv',row.names=FALSE,col.names=FALSE,sep=",")

## End of Document
