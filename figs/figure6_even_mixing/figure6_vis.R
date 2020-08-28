setwd("~/phase_transitions_in_metapopulation_synchrony/figs/figure6_even_mixing/output")
library(tidyverse)
library(ggthemr)
library(latex2exp)
ggthemr('fresh', spacing=3)
cmuserif = p$`CMU Serif`$family
thm = theme(panel.border = element_rect(colour = "#222222", fill = NA, size=0.75), 
            text=element_text(family=cmuserif,size=16), axis.title.y = element_text(angle = 0, hjust=1))

data = read.csv('metadata.csv') %>% full_join(read.csv('treatment_set.csv'), by="treatment")



data %>% 
  group_by(treatment) %>%
  mutate(mean_pcc = mean(summary_stat)) %>%
  ungroup %>%
  group_by(num_populations) %>% 
  filter(mean_pcc==max(mean_pcc)) %>%
  ggplot(aes(num_populations,migration_rate))  + 
  stat_function(fun = function(x) 1.0 - 1.0/x) + 
  geom_point(size=2) 
  
#+ 
 # coord_cartesian(xlim = c(0.0,1.0)) 

