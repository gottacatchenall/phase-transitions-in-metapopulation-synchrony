setwd("~/phase-transitions-in-metapopulation-synchrony/figs/figure8_sigma_gradient_single_panel/output")
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


data %>% 
  group_by(treatment) %>%
  filter(lambda==1.0, sigma==0.5) %>%
  ggplot(aes(migration_rate, summary_stat, group=factor(replicate) )) + 
  geom_line(size=1,alpha=0.3) +
  theme_minimal() +
  scale_x_continuous(limits = c(0.0,1), expand = c(0, 0), breaks = c(0.0, 0.25 ,0.5, 0.75, 1.0)) +
  labs(title='', y=TeX("$PCC$"), x=TeX("$m$"), color=TeX("$\\alpha$")) + 
  thm + 
  facet_grid(vars(sigma), vars(lambda)) +
  coord_cartesian(xlim = c(0.0,1.0), ylim=c(0,1)) 

convert_to_tex_label = function(string) {
  return(TeX(string))
}


plt=data %>% 
  group_by(treatment) %>%
  mutate(mean_pcc = mean(mean_cc)) %>%
  mutate(lowest_pcc = quantile(mean_cc, probs=c(0.025))) %>%
  mutate(lower_pcc = quantile(mean_cc, probs=c(0.25))) %>%
  mutate(higher_pcc = quantile(mean_cc, probs=c(0.75))) %>%
  mutate(highest_pcc = quantile(mean_cc, probs=c(0.975))) %>%
  mutate(sigma_facet = paste("$\\sigma =", as.numeric(sigma), "$")) %>%
  mutate(lambda_facet = paste("$\\lambda =", as.numeric(lambda), "$")) %>%
  ggplot(aes(migration_rate, mean_cc, group=factor(sigma))) + 
  geom_ribbon(aes(ymin=lower_pcc, ymax=higher_pcc, fill=factor(sigma)), size=1,alpha=0.4) +
  geom_line(aes(y=mean_pcc, color=factor(sigma)), size=0.5, linetype='dashed',) +
  geom_ribbon(aes(ymin=lowest_pcc, ymax=highest_pcc, fill=factor(sigma)), size=1,alpha=0.4) +
  theme(aspect.ratio = 1, legend.position = 'none') + 
  geom_hline(aes(yintercept=1), linetype='dashed',color='black') +
  scale_x_continuous(limits = c(0.0,1), expand = c(0, 0), breaks = c(0, 0.25,0.5, 0.75,1)) +
  labs(title='', y=TeX("$PCC$"), x=TeX("$m$"), color=TeX("$\\sigma$"), fill=TeX("$\\sigma$")) +
  facet_grid(vars(sigma_facet), vars(lambda_facet), labeller = as_labeller(convert_to_tex_label, label_parsed)) +
  thm

output_path = "~/phase_transitions_in_metapopulation_synchrony/writing/figs/figure5.png"
ggsave(output_path, plot=plt, dpi=320, width = 10, height = 10, units = "in", device=png)

get_logit_intercept = function(data, pcc, mig){
 m = glm(formula=pcc ~ mig, data=data, family="quasibinomial")
 return(m$coefficients[1])
}

get_logit_slope = function(data, pcc, mig ){
  m = glm(formula=pcc ~ mig, data=data, family="quasibinomial")
  return(m$coefficients[2])
}

data %>%
  group_by(treatment) %>%
  mutate(mean_pcc = mean(summary_stat)) %>%
  ungroup() %>% 
  group_by(lambda, sigma) %>%
  ggplot(aes(migration_rate, mean_pcc)) + facet_grid(vars(lambda), vars(sigma)) + geom_point()
  
data %>%
  group_by(treatment) %>%
  mutate(mean_pcc = mean(summary_stat)) %>%
  mutate(floor = min (summary_stat)) %>%
  ungroup() %>% 
  group_by(lambda, sigma) %>%
  mutate(intercept=get_logit_intercept(., mean_pcc, migration_rate)) %>%
  mutate(slope=get_logit_slope(., mean_pcc, migration_rate)) %>% 
  mutate(logit_fcn=(1.0)/(1.0+exp(-1*slope*migration_rate + intercept))) %>%
  ggplot(aes(migration_rate, mean_pcc, color=factor(sigma))) +
  geom_point( size=0.3) + 
  geom_line(size=0.5) +
  thm


  
