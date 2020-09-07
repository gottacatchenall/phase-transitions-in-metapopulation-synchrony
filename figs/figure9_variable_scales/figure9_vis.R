setwd("~/phase_transitions_in_metapopulation_synchrony/figs/figure9_variable_scales/output")
library(tidyverse)
library(ggthemr)
library(latex2exp)
library(extrafont)
loadfonts()
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

convert_to_tex_label = function(string) {
  return(TeX(string))
}

plt1= data %>% 
  filter(num_populations==20) %>%
  group_by(radius,treatment) %>%
  mutate(mean_pcc=mean(pcc)) %>%
  mutate(m_facet=paste("$m =", migration_rate, "$")) %>%
  mutate(np_facet=paste("$N_p =", num_populations, "$")) %>%
  ggplot(aes(radius,mean_pcc, color=factor(alpha), group=alpha)) + 
  geom_point(size=3,aes(shape=factor(alpha))) +
  geom_line() +
  scale_shape_manual(values = c(0, 1,5, 6)) + 
  theme(aspect.ratio=1) +
  ylim(0,1) +
  labs(x=TeX("$radius$"), y=TeX("$PCC$"), color=TeX("$\\alpha$"),shape=TeX("$\\alpha$"))  + 
  facet_wrap(. ~(m_facet), ncol=3, labeller = as_labeller(convert_to_tex_label, label_parsed)) + 
  thm 

output_path = "~/phase_transitions_in_metapopulation_synchrony/writing/figs/figure9.png"
ggsave(output_path, plot=plt1, dpi=320, width = 18, height = 10, units = "in", device=png())

plt2 =  data %>% 
  filter((num_populations) < 50) %>%
  group_by(radius,treatment) %>%
  mutate(mean_pcc=mean(pcc)) %>%
  mutate(m_facet=as.factor(paste("$m =", migration_rate, "$"))) %>%
  arrange(num_populations) %>%
  mutate(np_facet=paste("$N_p = ", num_populations, "$", sep="")) %>%
  mutate(np_facet=factor(np_facet, levels=c("$N_p = 5$", "$N_p = 10$", "$N_p = 20$","$N_p = 40$", "$N_p=80$"))) %>% 
  ggplot(aes(radius,mean_pcc, color=factor(alpha), group=alpha)) + 
  geom_point(size=1.5,aes(shape=factor(alpha))) +
  geom_line() +
  scale_shape_manual(values = c(0, 1,5, 6)) + 
  theme(aspect.ratio=1) + 
  facet_grid(vars(m_facet), vars(np_facet), labeller = as_labeller(convert_to_tex_label, label_parsed))+
  thm + theme(axis.text.x = element_text(size=12)) +
  labs(x=TeX("$radius$"), y=TeX("$PCC$"), color=TeX("$\\alpha$"),shape=TeX("$\\alpha$"))  
  

output_path = "~/phase_transitions_in_metapopulation_synchrony/writing/figs/figure10.png"
ggsave(output_path, plot=plt2, dpi=320, width = 12, height = 14, units = "in", device=png())



