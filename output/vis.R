library(tidyverse)
library(ggthemr)
library(latex2exp)
ggthemr('fresh')
thm = theme(panel.border = element_rect(colour = "#222222", fill = NA, size=0.75), 
            text=element_text(family="Iosevka Semibold",size=16), axis.title.y = element_text(angle = 0, hjust=1))
data = read.csv('metadata.csv') %>% full_join(read.csv('treatment_set.csv'), by="treatment")

data %>% 
  group_by(treatment) %>%
  mutate(mean_pcc = mean(summary_stat)) %>%
  ggplot(aes(migration_rate_distribution, mean_pcc, color=factor(alpha) )) + 
  geom_point(size=2,alpha=0.5) +
  theme_minimal() +
  scale_x_continuous(limits = c(0.01,1), expand = c(0, 0), breaks = c(0.01, 0.25 ,0.5, 0.75, 1.0)) +
  labs(title='', y=TeX("$PCC$"), x=TeX("$m$"), fill=TeX("$\alpha$")) + 
  thm + 
  coord_cartesian(xlim = c(0.01,1.0), ylim=c(0,1)) 


data %>% 
  group_by(treatment) %>%
  mutate(mean_pcc = mean(summary_stat)) %>%
  mutate(lower_pcc = quantile(summary_stat, probs=c(0.025))) %>%
  mutate(upper_pcc = quantile(summary_stat, probs=c(0.975))) %>%
  ggplot(aes(migration_rate_distribution, summary_stat, group=factor(alpha))) + 
  geom_ribbon(aes(ymin=lower_pcc, ymax=upper_pcc, fill=factor(alpha)), size=1,alpha=0.4) +
  theme_minimal() +
  scale_x_continuous(limits = c(0.01,1), expand = c(0, 0), breaks = c(0.01, 0.25 ,0.5, 0.75, 1.0)) +
  labs(title='', y=TeX("$PCC$"), x=TeX("$m$"), fill=TeX("$\alpha$")) + 
  thm + 
  coord_cartesian(xlim = c(0.01,1.0)) 

