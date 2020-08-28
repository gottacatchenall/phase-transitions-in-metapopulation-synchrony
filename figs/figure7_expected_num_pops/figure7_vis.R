setwd("~/phase_transitions_in_metapopulation_synchrony/figs/figure7_expected_num_pops/output")
library(tidyverse)
library(ggthemr)
library(latex2exp)
ggthemr('fresh', spacing=3)
cmuserif = p$`CMU Serif`$family
thm = theme(panel.border = element_rect(colour = "#222222", fill = NA, size=0.75), 
            panel.spacing=unit(3, "lines"),
            text=element_text(family=cmuserif,size=20), axis.title.y = element_text(angle = 0, vjust=0.5),
            axis.title = element_text(margin = margin(t = 20, r = 20, b = 0, l = 0)),
            axis.text = element_text(size=14),
            # The new stuff
            strip.text = element_text(size = 22),
            strip.text.y = element_text(size = 22, angle = 0, vjust=0.5))

data = read.csv('metadata.csv') %>% full_join(read.csv('treatment_set.csv'), by="treatment")

compute_exp_pops = function(m_max){
  np = (1.0)/(1.0 - m_max)
  return(np)
}

data %>% 
  group_by(treatment) %>%
  filter(alpha==10) %>%
  mutate(mean_pcc = mean(summary_stat)) %>%
  ggplot(aes(migration_rate, mean_pcc)) + geom_point()

data %>% 
  group_by(treatment) %>%
  mutate(mean_pcc = mean(summary_stat)) %>%
  ungroup %>%
  group_by(alpha) %>% 
  filter(abs(mean_pcc - max(mean_pcc)) < 0.01) %>%
  mutate(expected_num_pops = compute_exp_pops(migration_rate)) %>%
  mutate(mean_critical_migration=mean(migration_rate)) %>%
  mutate(expected_num_pops = compute_exp_pops(mean_critical_migration)) %>%
  ggplot(aes(alpha, expected_num_pops))  + 
  geom_point() +
  geom_hline(aes(yintercept=15), linestyle='dashed') + scale_y_continuous(limits=c(0,18))

exp_data = data %>% 
  group_by(treatment) %>%
  mutate(mean_pcc = mean(summary_stat)) %>%
  ungroup %>%
  group_by(alpha) %>% 
  filter(abs(mean_pcc - max(mean_pcc)) < 0.001) %>%
  ggplot(aes(alpha, mean_pcc))  + 
  geom_point(size=2) 

grid.arrange(exp_pops, exp_data)
#+ 
# coord_cartesian(xlim = c(0.0,1.0)) 

