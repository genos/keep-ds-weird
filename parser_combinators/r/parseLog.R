library('Ramble')

p <- function(result, collapse='') paste0(result, collapse=collapse)

sensorID <- symbol('A') %alt% symbol('B') %alt% symbol('C')

date <- (
  natural()   %then%
  symbol('-') %then%
  natural()   %then%
  symbol('-') %then%
  natural()   %using%
  p
)

time <- (
  natural()   %then%
  symbol(':') %then%
  natural()   %then%
  symbol(':') %then%
  natural()   %using%
  p
)

fahrenheit <- (
  natural()   %then%
  symbol('.') %then%
  natural()   %using%
  function(result) as.numeric(p(result))
)

humidity <- (
  natural()   %then%
  symbol('%') %using%
  function(result) as.numeric(result[[1]])
)

direction <- (
  symbol('N') %alt% symbol('S') %alt% symbol('E') %alt% symbol('W')
)

speed <- natural() %using% as.numeric

wind <- (
  direction %then%
  speed     %using%
  function(result) p(result, collapse='@')
)

entry <- (
  sensorID    %then%
  date        %then%
  maybe(time) %then%
  fahrenheit  %then%
  humidity    %then%
  maybe(wind)
)

entries <- function(raw) {
  data <- t(sapply(raw, function(row) entry(row)$result))
  df <- as.data.frame(data)
  colnames(df) <- c("sensorID", "date", "time", "temp_F", "humidity_%", "wind")
  rownames(df) <- NULL
  df[df == "NULL"] <- NA
  df
}

# main event
print(entries(readLines("../data.log")))
