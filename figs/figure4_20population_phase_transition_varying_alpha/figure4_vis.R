setwd("~/phase-transitions-in-metapopulation-synchrony/figs/figure4_20population_phase_transition_varying_alpha/output")
library(tidyverse)
library(ggthemr)
library(latex2exp)
library(extrafont)
loadfonts()
ggthemr('fresh', spacing=3)
cmuserif = pdfFonts()$`CM Roman`$family
thm = theme(panel.border = element_rect(colour = "#222222", fill = NA, size=0.75), 
            panel.spacing=unit(3, "lines"),
            text=element_text(family=cmuserif,size=20), axis.title.y = element_text(angle = 0, vjust=0.5),
            axis.title = element_text(margin = margin(t = 20, r = 20, b = 0, l = 0)),
            axis.text = element_text(size=14),
            panel.grid = element_line(size=1, linetype="dotted"),
            # The new stuff
            strip.text = element_text(size = 22),
            strip.text.y = element_text(size = 22, angle = 0, vjust=0.5))

data = read.csv('metadata.csv') %>% full_join(read.csv('treatment_set.csv'), by="treatment")


data %>% 
  group_by(treatment) %>%
  filter(lambda==1.0, sigma==0.5) %>%
  ggplot(aes(migration_rate, summary_stat, group=factor(replicate) )) + 
  geom_line(size=1,alpha=0.3) +
  theme_minimal() +
  scale_x_continuous(limits = c(0.0,1), expand = c(0, 0), breaks = c(0.0, 0.25 ,0.5, 0.75, 1.0)) +
  labs(title='', y=TeX("$PCC$"), x=TeX("$m$"), color=TeX("$\\alpha$")) + 
  thm + 
  facet_grid(vars(sigma), vars(alpha)) +
  coord_cartesian(xlim = c(0.0,1.0), ylim=c(0,1)) 

convert_to_tex_label = function(string) {
  return(TeX(string))
}

plt = data %>% 
  group_by(treatment) %>%
  mutate(mean_pcc = mean(mean_cc)) %>%
  mutate(lowest_pcc = quantile(mean_cc, probs=c(0.025))) %>%
  mutate(lower_pcc = quantile(mean_cc, probs=c(0.25))) %>%
  mutate(higher_pcc = quantile(mean_cc, probs=c(0.75))) %>%
  mutate(highest_pcc = quantile(mean_cc, probs=c(0.975))) %>%
  mutate(alpha_facet = paste("$\\alpha = ", alpha, "$", sep="")) %>%
  mutate(alpha_facet = factor(alpha_facet, levels=c("$\\alpha = 0$", "$\\alpha = 10$", "$\\alpha = 20$","$\\alpha = 30$"))) %>%
  arrange(alpha) %>%
  ggplot(aes(migration_rate, mean_cc, group=factor(alpha), fill=factor(alpha))) + 
  geom_ribbon(aes(ymin=lower_pcc, ymax=higher_pcc), size=1,alpha=0.4) +
  geom_line(aes(y=mean_pcc, color=factor(alpha)), size=0.5, linetype='dashed') +
  geom_ribbon(aes(ymin=lowest_pcc, ymax=highesst_pcc), size=1,alpha=0.4) +
  theme_minimal() +
  theme(aspect.ratio = 1, legend.position = 'none') + 
  geom_hline(aes(yintercept=1), linetype='dashed',color='black') +
  scale_x_continuous(limits = c(0.0,1), expand = c(0, 0), breaks = c(0, 0.25,0.5, 0.75, 1)) +
  labs(title='', y=TeX("$PCC$"), x=TeX("$m$"), color=TeX("$\\alpha$"), fill=TeX("$\\alpha$")) + 
  facet_wrap(. ~ alpha_facet, ncol=2, labeller= as_labeller(convert_to_tex_label, label_parsed)) +
  thm + 
  coord_cartesian(xlim = c(0.0,1.0), ylim=c(0.0,1.0)) 

plt

d = seq(0, 1, by=0.01)
alpha = rep(c(0, 10, 20, 30))


exp_kern = exp(-1*d*alpha)


output_path = "~/phase_transitions_in_metapopulation_synchrony/writing/figs/figure4.png"
ggsave(output_path, plot=plt, dpi=320, width = 12, height = 8, units = "in", device=png())


