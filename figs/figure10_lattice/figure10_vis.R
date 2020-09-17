setwd("~/phase-transitions-in-metapopulation-synchrony/figs/figure10_lattice/output")
library(tidyverse)
library(ggthemr)
library(latex2exp)
library(extrafont)
loadfonts()
ggthemr('fresh', spacing=3, layout='scientific')
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


data %>%
  group_by(treatment) %>%
  mutate(var_meancc=var(mean_cc)) %>% 
    ggplot(aes(migration_rate, var_meancc)) + geom_point() + facet_wrap(. ~ alpha)
