library(ggplot2)
library(ggnet)
library(gridExtra)
library(tikzDevice)
library(tidyverse)
library(extrafont)
library(latex2exp)
library(Cairo)
library(extrafont)
loadfonts()
setwd("~/phase_transitions_in_metapopulation_synchrony/figs")
loadfonts()
cmuserif = p$`CMU Serif`$family
## ============================================ 
## DISPERSAL KERNEL PLOTTING / FIG 1
## ============================================
exp_kern = function(alpha, d_ij){
    return(exp(-1*alpha*d_ij))
}

gauss_kern = function(alpha, d_ij){
    return(exp(-1*d_ij^2*alpha^2))
}


get_pop_points = function(x_vals, y_vals, alpha, mig_prop, kernel=exp_kern, kernel_name="Exp.", xaxis=F, yaxis=F){
    # make df with all pairwise and group by indiv pairwise val
    df = data.frame(matrix(ncol=5))
    
    line_ct = 1
    grp_ct = 0 
    
    # make a dis potential first
    
    npops = length(x_vals)
    
    dispersal_potential = matrix(nrow=npops, ncol=npops)
    for (pt_ct in seq(1, n_pops)){
        s = 0
        for (pt_ct2 in seq(1, n_pops)){
            x1 = x_vals[pt_ct] 
            y1 = y_vals[pt_ct] 
            x2 = x_vals[pt_ct2] 
            y2 = y_vals[pt_ct2] 
            
            dist = sqrt((x2-x1)^2 + (y2-y1)^2)
            
            dispersal_potential[pt_ct, pt_ct2] = kernel(alpha, dist)
            
            s = s + dispersal_potential[pt_ct, pt_ct2] 
        }
        for (pt_ct2 in seq(1, n_pops)){
            dispersal_potential[pt_ct, pt_ct2]  = dispersal_potential[pt_ct, pt_ct2]  / s
        }
    }
    
    for (pt_ct in seq(1, n_pops)){
        for (pt_ct2 in seq(1, n_pops)){
            x1 = x_vals[pt_ct] 
            y1 = y_vals[pt_ct] 
            x2 = x_vals[pt_ct2] 
            y2 = y_vals[pt_ct2] 
            #opac =1
              opac = 0.1 + dispersal_potential[pt_ct, pt_ct2] * 5
              width = dispersal_potential[pt_ct, pt_ct2] * 8
              
              
              df[line_ct,] = c(x1,y1, grp_ct, opac, width)
              line_ct = line_ct + 1
              df[line_ct,] = c(x2,y2, grp_ct, opac, width)
              line_ct = line_ct + 1
              grp_ct = grp_ct + 1
        }
    }
    colnames(df) = c("x", "y", "grp", "opac", "width")
    
    plt = ggplot(df, aes(x,y, group=grp)) + 
        geom_line(alpha=df$opac, size=df$width, color='#222222')+ 
        theme(aspect.ratio=1, text=element_text(cmuserif)) +
        theme(axis.text.x = element_text(size=14),
              axis.text.y = element_text(size=14),
              axis.title  = element_text(size=16)) +
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), panel.border = element_rect(fill=NA, size=1, colour = "#222222"))+ 
        geom_point(shape=1, size=3, color='black') + geom_point(alpha=0.3, size=2, color='dodgerblue')
    
    
    if (xaxis==F){ 
        plt = plt + scale_x_continuous(breaks=c(0,1)) 
    }
    
    if (yaxis == F){
        plt = plt + scale_y_continuous(breaks=c(0,1))
    }
    
    if (xaxis == T){
        plt = plt +
        scale_x_continuous(breaks=c(0,1)) +  
        labs(x=TeX("$x$")) 
    }
    if (yaxis == T){
        plt = plt + scale_y_continuous(breaks=c(0,1)) + labs(y=TeX("$y$"))
    }
    title_exp = (sprintf("%s Kernel, $\\alpha = %d$", kernel_name, alpha))
    plt = plt + labs(title=TeX(title_exp))
    
    
    return(plt + coord_cartesian(xlim=c(0,1), ylim=c(0,1)))
}
#tikz(file = "~/phase_transitions_in_metapopulation_synchrony/writing/figure0.tex", width = 12, height = 8, standAlone = T)

n_pops = 20

set.seed(5)

x_vals = runif(n_pops, 0, 1)    
y_vals = runif(n_pops, 0, 1)

plt1 = get_pop_points(x_vals, y_vals, 2, 1.5, kernel=exp_kern,yaxis=T)
plt2 = get_pop_points(x_vals, y_vals, 7, 1.5, kernel=exp_kern, yaxis=F, xaxis=F)
plt3 = get_pop_points(x_vals, y_vals, 12, 1.5, kernel=exp_kern, yaxis=F, xaxis=F)
plt4 = get_pop_points(x_vals, y_vals, 2, 1.5, kernel=gauss_kern, yaxis=T,xaxis=T,kernel_name="Gauss")
plt5 = get_pop_points(x_vals, y_vals, 7, 1.5, kernel=gauss_kern, xaxis=T,kernel_name="Gauss")
plt6 = get_pop_points(x_vals, y_vals, 12, 1.5, kernel=gauss_kern, xaxis=T, yaxis=F, kernel_name="Gauss")


g = grid.arrange(plt1,plt2,plt3,plt4,plt5,plt6, nrow=2, padding=unit(3.5, 'line'))


output_path = "~/phase_transitions_in_metapopulation_synchrony/writing/figs/figure1.png"
ggsave(output_path, plot=g, dpi=320, width = 12, height = 8, units = "in", device=png())


