#!/usr/bin/env Rscript
# Poll the openfootball feed and fill group-stage results into results_2026.csv.
# Row order and format of the csv are preserved (rows are kept in calendar order);
# matches are located by team pair, and goals are mapped onto the csv's Home/Away
# orientation (some workbook fixtures are flipped vs the official one).
# Knockout results are not handled here: results_elim_2026.csv stays manual.

suppressMessages(library(jsonlite))

url <- 'https://raw.githubusercontent.com/openfootball/worldcup.json/master/2026/worldcup.json'
wc <- tryCatch(fromJSON(url, simplifyVector = FALSE),
               error = function(e) {
                 message('Could not fetch/parse feed, leaving csv untouched: ', conditionMessage(e))
                 NULL
               })
if (is.null(wc)) quit(save = 'no', status = 0)

results <- read.csv('results_2026.csv', stringsAsFactors = FALSE,
                    na.strings = c('NA',''), check.names = FALSE)

# openfootball team name -> workbook team name
rename <- c('Bosnia & Herzegovina' = 'Bosnia-Herzegovina',
            'Czech Republic'       = 'Czechia',
            'Curaçao'         = 'Curacao',
            'Turkey'               = 'Turkiye')
FixName <- function(x) ifelse(is.na(rename[x]), x, unname(rename[x]))

PairKey <- function(a, b) paste(pmin(a, b), pmax(a, b))
results.key <- PairKey(results$Home, results$Away)

n.updated <- 0
for (m in wc$matches) {
  if (is.null(m$group) || is.null(m$score) || is.null(m$score$ft)) next
  t1 <- FixName(m$team1)
  t2 <- FixName(m$team2)
  i <- which(results.key == PairKey(t1, t2))
  if (length(i) != 1) {
    message('No unique csv row for feed match: ', m$team1, ' v ', m$team2)
    next
  }
  ft <- unlist(m$score$ft)
  hg <- if (results$Home[i] == t1) ft[1] else ft[2]
  ag <- if (results$Home[i] == t1) ft[2] else ft[1]
  res <- if (hg > ag) results$Home[i] else if (hg < ag) results$Away[i] else 'Draw'
  changed <- !identical(c(results$`Home Goals`[i], results$`Away Goals`[i]), c(hg, ag)) ||
             !identical(results$Result[i], res)
  if (changed) {
    results$`Home Goals`[i] <- hg
    results$`Away Goals`[i] <- ag
    results$Result[i] <- res
    n.updated <- n.updated + 1
    message('Updated match ', results$Match[i], ': ',
            results$Home[i], ' ', hg, '-', ag, ' ', results$Away[i])
  }
}

if (n.updated > 0) {
  write.csv(results, 'results_2026.csv', row.names = FALSE, na = '')
}
message(n.updated, ' result(s) updated, ',
        sum(!is.na(results$Result)), '/', nrow(results), ' group games have results')
