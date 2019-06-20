## Shiny app 과제 - 회귀분석 summary와 plot 보여주는 앱 만들기 

# mtcars: 미국의 잡지로 차종류에 따른 특성 보여줌
#fit=lm(mpg~wt,data=mtcars)
#summary(fit)

library(ggplot2)
#ggplot(data=mtcars, aes(x=wt,y=mpg)) + geom_point()+stat_smooth(method='lm')

ui=fluidPage( 
  selectInput("x","Select independent variable",
              choices=setdiff(colnames(mtcars),"mpg")),
  actionButton("analysis","Analysis"),
  verbatimTextOutput("result"), #회귀분석 결과 보여줌 
  plotOutput("plot") #plot보여줌 
  
) 


#server interface
server=function(input,output){ 
  
  lmEquation=reactive({ #반응성 객체를 만들어줌 
    paste0("lm(mpg~",input$x,",data=mtcars)") #문자를 보여줌
  })
  
  output$result=renderPrint({
    
    input$analysis
    
    isolate({
      
      #lmEquation()
      cat(lmEquation())
      fit=eval(parse(text=lmEquation())) #eval: 실행, parse: text를 언어로 바꿔줌 
      summary(fit)  
    })
  })
  
  
  
  output$plot=renderPlot({
    
    isolate({
      fit=eval(parse(text=lmEquation()))
      equation=paste0(round(fit$coef[2],1), input$x, ifelse(fit$coef[1]>=0,"+","-"), abs(round(fit$coef[1],1)))
    })
    
    ggplot(data=mtcars, aes_string(x=input$x, y="mpg"))+
      geom_point()+
      stat_smooth(method="lm")+
      labs(title=equation)
  })
  
  
  
} 

shinyApp(ui,server)
