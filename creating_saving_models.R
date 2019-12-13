library(tidyverse)
library(caret)
set.seed(123)
dat = faithful %>% 
  as_tibble() %>%
  mutate(id = row_number())

dat_train = dat %>% 
  sample_frac(0.9)

dat_test = dat %>%
  anti_join(dat_train, by = 'id') %>%
  select(-id)

dat_train = dat_train %>%
  select(-id)

dat_train_pp_mod = preProcess(dat_train, method = c('scale', 'center'))
dat_train_pp = predict(dat_train_pp_mod, dat_train)

train_control = trainControl(method = 'cv')
mod_lm = train(
  eruptions ~ waiting, 
  dat_train_pp,
  method = 'lm',
  trControl = train_control
)


saveRDS(dat_train_pp_mod, 'pre_processing_model.RDS')
saveRDS(mod_lm, 'lm_model.RDS')

