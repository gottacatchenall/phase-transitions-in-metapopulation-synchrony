setwd("~/phase-transitions-in-metapopulation-synchrony/figs/figure6_even_mixing/output")
library(tidyverse)
library(ggthemr)
library(latex2exp)
ggthemr('fresh', spacing=3)
cmuserif = pdfFonts()$`CMU Serif`$family
thm = theme(panel.border = element_rect(colour = "#222222", fill = NA, size=0.75), 
            panel.spacing=unit(3, "lines"),
            text=element_text(family=cmuserif,size=20), axis.title.y = element_text(angle = 0, vjust=0.5),
            axis.title = element_text(margin = margin(t = 20, r = 20, b = 0, l = 0)),
            axis.text = element_text(size=14),
            panel.grid = element_line(size=0.5, linetype="dotted"),
            # The new stuff
            strip.text = element_text(size = 22),
            strip.text.y = element_text(size = 22, angle = 0, vjust=0.5))
data = read.csv('metadata.csv') %>% full_join(read.csv('treatment_set.csv'), by="treatment")



plt = data %>% 
  group_by(num_populations, alpha) %>% 
  mutate(max_pcc = (max(mean_cc))) %>%
  filter(abs(mean_cc - max_pcc) < 0.01) %>%
  ungroup() %>%
  group_by(num_populations, alpha) %>% 
  mutate(low = quantile(migration_rate,0.25), high=quantile(migration_rate, 0.75)) %>%
  mutate(lowest = quantile(migration_rate,0.025), highest=quantile(migration_rate, 0.975)) %>%
  ggplot(aes(num_populations,migration_rate, fill=factor(alpha)))  + 
  geom_ribbon(aes(ymin=lowest, ymax=highest), alpha=0.3) +
  geom_ribbon(aes(ymin=low, ymax=high), alpha=0.4) +
 # geom_point(aes(y=migration_rate, color=factor(alpha))) + 
  stat_function(fun = function(x) 1.0 - 1.0/x) + 
  labs(x=TeX("$N_p$"), y=TeX("$m$"))  + 
  facet_wrap(. ~ alpha) + 
  scale_x_continuous(breaks=seq(2,26,by=2), limits=c(2,26)) +
  scale_y_continuous(breaks=c(0.5,0.6,0.7,0.8,0.9,1.0), limits=c(0.5,1)) +
  thm +
  coord_cartesian(ylim = c(0.5,1.0)) 
  


output_path = "~/phase_transitions_in_metapopulation_synchrony/writing/figs/figure6.png"
ggsave(output_path, plot=plt, dpi=320, width = 18, height = 8, units = "in", device=png())

#+ 
 # coord_cartesian(xlim = c(0.0,1.0)) 

