setwd("~/phase_transitions_in_metapopulation_synchrony/figs/figure2_synchrony_example/output")
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


data = read.csv('metadata.csv') %>% full_join(read.csv('abundances.csv'), by="treatment")

convert_to_tex_label = function(string) {
  return(TeX(string))
}

plt = data %>% 
  mutate(num_pops_facet=paste("$N_p = ", num_populations, "$")) %>%
  mutate(migration_facet=paste("$m = ", migration_rate, "$")) %>%
  ggplot(aes(timestep, abundance, group=interaction(replicate,population), color=factor(population))) + 
    geom_line(alpha=(0.7), size=1.3) + 
    facet_grid(vars(num_pops_facet), vars(migration_facet), labeller = as_labeller(convert_to_tex_label, label_parsed)) +
    labs(title='', y=TeX("$Abundance$"), x=TeX("$m$"), color="Population") +
    geom_hline(aes(yintercept=1.0) ,linetype="dashed", color='black') + 
    thm



output_path = "~/phase_transitions_in_metapopulation_synchrony/writing/figs/figure2.png"
ggsave(output_path, plot=plt, dpi=320, width = 18, height = 10, units = "in", device=png())

