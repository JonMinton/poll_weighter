#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


source("scripts/get_data.R")


curvenum_party_lookup <- unique(dta_flat$party)
n <- length(curvenum_party_lookup)
names(curvenum_party_lookup) <- 0:(n-1)
rm(n)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  point_clicked <- reactive({
    s <- event_data("plotly_click")
  })
    

  output$pollplot <- renderPlotly({
    
    if (input$add_gam == TRUE){
      browser()
      dta_flat <- dta_flat %>% 
        group_by(party) %>% 
        nest() %>% 
        mutate(mdl = map(data, ~gam(pct ~ s(date), data = .))) %>% 
        mutate(pred_dta = map(data, ~data_frame(date = .$date))) %>% 
        mutate(predictions = map2(mdl, pred_dta, ~predict(.x, newdata = .y))) %>% 
        select(data, party, predictions) %>% 
        unnest() %>% 
        select(-predictions, predictions)
    }
    
    dta_flat %>% 
      group_by()
    if (length(input$pollster) == 1 && input$pollster == "All"){
      dta_flat %>% 
        plot_ly(x = ~date, y = ~pct, color = ~party, type = "scatter", mode = "markers",
                symbol = ~party, hoverinfo = "text", 
                text = ~paste(date, party, pct, provider),
                colors = c("blue", "green", "red", "orange", "yellow", "purple")) %>% 
        layout(
          title = "Poll results over time", 
          xaxis = list(
            rangeselector = list(
              rangeslider = list(type = "date")
            ),
            title = "Date"
          ),
          yaxis = list(
            title = "Percent"
          )
          
        ) -> p
      
      #    plotly_json(p)
      
      s <- point_clicked()
      if(!is.null(s)){
        
        
        p <- style(p, marker = list(opacity = 0.2), 
                   traces = setdiff(1:6, (s$curveNumber[1]+1))
        )
        
      }
      
      
    } else {
      dta_flat %>% 
        filter(provider %in% input$pollster) %>% 
        plot_ly(x = ~date, y = ~pct, color = ~party, type = "scatter", mode = "markers",
                symbol = ~party, hoverinfo = "text", 
                text = ~paste(date, party, pct, provider),
                colors = c("blue", "green", "red", "orange", "yellow", "purple")) %>% 
        layout(
          title = "Poll results over time", 
          xaxis = list(
            rangeselector = list(
              rangeslider = list(type = "date")
            ),
            title = "Date"
          ),
          yaxis = list(
            title = "Percent"
          )
          
        ) -> p
            
      
    }
    
    if (input$add_gam == TRUE){
      p <- p %>% 
        add_lines( y = ~predictions)
      
    }
    
  
    p 
  })
  
  output$rawhover <- renderPrint({
    
    s <- event_data("plotly_hover")
    if(is.null(s)) "Nothing!" else s
  })
  
  output$rawclick <- renderPrint({
    
    s <- event_data("plotly_click")
    if(is.null(s)) "Nothing!" else s
  })
  
  
})
