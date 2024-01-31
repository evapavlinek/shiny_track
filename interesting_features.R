# reactiveFileReader works by periodically checking the file's last modified time; if it has changed, then the file is re-read 
filepath <- "data.csv"
server <- function(input, output, session) {
  reactive_data <- reactiveFileReader(
    intervalMillis = 1000,
    session = session, 
    filePath = filepath,
    readFunc = read.csv
  )
}



# dynamic programming for adding dropdown menu elements
tasks <- apply(task_data, 1, function(row) { 
  taskItem(text = row[["text"]],
           value = row[["value"]])
})
dropdownMenu(type = "tasks", .list = tasks)



# add buttons to DT tables
datatable(station_trips_df, rownames = FALSE, extensions = 'Buttons', 
          options = list(dom ='Bfrtip', buttons =c('copy','csv','excel','pdf','print'))
          )