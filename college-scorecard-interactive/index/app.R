#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)

load("scorecard.Rda")

pcip_abr <- c("allPCIP", "PCIP01", "PCIP03", "PCIP04", "PCIP05", "PCIP09", "PCIP10", "PCIP11", "PCIP12", "PCIP13", "PCIP14", "PCIP15", "PCIP16", "PCIP19", "PCIP22", "PCIP23", "PCIP24", "PCIP25", "PCIP26", "PCIP27", "PCIP29", "PCIP30", "PCIP31", "PCIP38", "PCIP39", "PCIP40", "PCIP41", "PCIP42", "PCIP43", "PCIP44", "PCIP45", "PCIP46", "PCIP47", "PCIP48", "PCIP49", "PCIP50", "PCIP51", "PCIP52", "PCIP54")
pcip_full <- c("All", "Agriculture, Agriculture Operations, and Related Sciences", "Natural Resources and Conservation", "Architecture and Related Services", "Area, Ethnic, Cultural, Gender, and Group Studies", "Communication, Journalism, and Related Programs", "Communications Technologies/Technicians and Support Services", "Computer and Information Sciences and Support Services", "Personal and Culinary Services", "Education", "Engineering", "Engineering Technologies and Engineering-Related Fields", "Foreign Languages, Literatures, and Linguistics", "Family and Consumer Sciences/Human Sciences", "Legal Professions and Studies", "English Language and Literature/Letters", "Liberal Arts and Sciences, General Studies and Humanities", "Library Science", "Biological and Biomedical Sciences", "Mathematics and Statistics", "Military Technologies and Applied Sciences", "Multi/Interdisciplinary Studies", "Parks, Recreation, Leisure, and Fitness Studies", "Philosophy and Religious Studies", "Theology and Religious Vocations", "Physical Sciences", "Science Technologies/Technicians", "Psychology", "Homeland Security, Law Enforcement, Firefighting and Related Protective Services", "Public Administration and Social Service Professions", "Social Sciences", "Construction Trades", "Mechanic and Repair Technologies/Technicians", "Precision Production", "Transportation and Materials Moving", "Visual and Performing Arts", "Health Professions and Related Programs", "Business, Management, Marketing, and Related Support Services", "History")

xaxis_abr <- c("ADM_RATE", "SATVRMID", "SATMTMID", "SATWRMID", "UGDS", "COSTT4_A", "COSTT4_P", "AVGFACSAL", "PFTFAC")
xaxis_full <- c("Admissions Rate", "SAT verbal median", "SAT math median", "SAT written median", "Enrollment (undergrad)", "Cost academic year institutions", "Cost program year institutions", "Faculty Salary Average", "Full time faculty percent")
yaxis_abr <- c("CDR3", "COMPL_RPY_7YR_RT", "GRAD_DEBT_MDN", "mn_earn_wne_p10")
yaxis_full <- c("Default rate - 3 year cohort", "Repayment rate 7 year after completion", "Median debt", "Median earnings")
  
  
# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("College Scorecard Interactive"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        
        selectInput("field",
                    "Choose colleges with field of study:",
                    choices = pcip_abr,
                    selected = "allPCIP"),
        
        selectInput("x.axis",
                     "Choose the x-axis:",
                     choices = xaxis_abr,
                     selected = "ADM_RATE"),
       
        selectInput("y.axis",
                    "Choose the y-axis:",
                    choices = yaxis_abr,
                    selected = "mn_earn_wne_p10")
      ),
      
      
      mainPanel(
         plotOutput("earnplot")
      )
   )
))


server <- shinyServer(function(input, output) {
    
  colleges <- reactive(function(){
    if(input$field == "allPCIP"){
      scorecard
    }else{
      scorecard %>% filter(scorecard[,eval(input$field)] > 0.0)
    }
  })
   
  output$earnplot <- renderPlot({
      # generate plot
      p <- ggplot(colleges(), mapping = aes_string(x = input$x.axis, y = input$y.axis)) + 
       geom_point()
    
      print(p)
   })
})

# Run the application 
shinyApp(ui = ui, server = server)

