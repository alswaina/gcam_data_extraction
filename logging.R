library(xlsx, warn.conflicts = FALSE)

log.table <- data.frame(
  Query.number = double(),
  Query.name = character(),
  Regions = character(),
  Records.count = double(),
  DB.name = character(),
  Scenario.name = character(),
  Succeed = logical(),
  Output.filename = character(),
  ExecTime = character()
)

log.initTable <- function(){
  return(
    data.frame(
      Query.number = double(),
      Query.name = character(),
      Regions = character(),
      Records.count = double(),
      DB.name = character(),
      Scenario.name = character(),
      Succeed = logical(),
      Output.filename = character(),
      ExecTime = character()
    ))
}

log.addRecord <- function(
  Query.number,
  Query.name,
  Regions,
  DB.name,
  Records.count,
  Scenario.name,
  Succeed,
  Output.filename,
  ExecEnd, 
  ExecStart){
  data <- data.frame(
    Query.number = Query.number, 
    Query.name = Query.name, 
    DB.name = DB.name,
    Records.count = Records.count,
    Scenario.name = Scenario.name,
    Succeed = Succeed,
    Output.filename = Output.filename,
    ExecTime = round(difftime(ExecEnd, ExecStart, units = "min"), 2), 
    
    Regions = I(list(Regions))
  )
  
  log.table <- rbind(log.table, data)
  assign("log.table", log.table, envir = .GlobalEnv)
}

log.getTable <- function(){
  return(log.table)
}

log.write <- function(file.name, file.path) {
  write.xlsx2(
    x =  log.getTable(),
    file = paste0(file.path, "/", file.name),
    row.names = FALSE
  )
}

#prints
log.executionHeaderPrint <- function(top){
  if(top){
    exec.decoration <- paste0("\n--------------------------------[", "EXECUTION STARTED", "]--------------------------------", "\n")
    cat(exec.decoration)
  }
  else{
    exec.decoration <- paste0("\n--------------------------------[", "EXECUTION FINISHED", "]--------------------------------", "\n")
    cat(exec.decoration)
  }
}

log.rootHeaderPrint <- function(type, header, top = TRUE){
  if(top){
    cat(paste0("\n*-*-* [ ", type,": ",header," ] *-*-*", "\n\n"))
  }
  else{
    cat(paste0("\n*-*-*", "\n"))
  }
}

log.nodeHeaderPrint <- function(type, counter, title, scenario.name=""){
  if(type=="DB"){
    query.decoration <- paste0("\n", type, "_", counter, ": ", title," [scenario: ",scenario.name, "]", "\n")
  }else{
    query.decoration <- paste0("\n", type, "_", counter, ": ", title, "\n")
  }
  cat(query.decoration)
}

log.envPrint <- function(db.path, scenario.name){
  #DB_PATH
  print(paste0("DB_PATH: ", db.path), quote=FALSE)
  
  #SCENARIO
  print(paste0("ON_SCENARIO: ", scenario.name), quote=FALSE)
  noquote(" ")
}