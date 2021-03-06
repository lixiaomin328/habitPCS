source('libraries.R')
source("proventix_fn.R")

hand_data_habit = data.table(read.csv('dataWithInterventionDate.csv'))
hand_data_habit[,interventionDate:=mdy(preventionDate)]
preint_data     = hand_data_habit[!is.na(interventionDate) & date<=interventionDate]
postint_data    = hand_data_habit[!is.na(interventionDate) & date>interventionDate]
rm(hand_data_habit)
p_list          = as.list(unique(preint_data$hospital_tag))
all_lasso_preint = lapply(p_list, 
                   function(p) tryCatch(cvlasso_individual(data = preint_data[hospital_tag == p], type = 'all'), 
                                        error = function(e) NULL))

save(all_lasso_preint ,file = 'lasso_preint.RData')