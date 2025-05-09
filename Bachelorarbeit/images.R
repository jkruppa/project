pacman::p_load(tidyverse, patchwork)
cbb_pal <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
             "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

p1 <- tibble(x = c(0, 4, 8, 18, 22),
             y = 0) |> 
  ggplot(aes(x, y)) +
  theme_minimal() +
  annotate("segment", x = 0, xend = 4, y = 0, yend = 0, color = "gray80",
           linewidth = 1.5, linetype  = 2) +
  annotate("segment", x = 4, xend = 18, y = 0, yend = 0, color = "gray60",
           linewidth = 1.5) +
  annotate("segment", x = 18, xend = 22, y = 0, yend = 0, color = "gray80",
           linewidth = 1.5, linetype  = 2) +
  geom_point(size = c(3.5,3.5,3.5,3.5,3.5),
             color = c(cbb_pal[2], cbb_pal[6], cbb_pal[2], cbb_pal[6], cbb_pal[2])) +
  scale_x_continuous(breaks = c(0, 4, 8, 13, 18, 22),
                     labels = c("4 Wochen\nvorher", "0 Woche",
                                "4 Woche", "8 Woche", "12 Woche", "14 Woche"),
                     limits = c(-1, 24),
                     name = "Zeitlicher Ablauf [Wochen]") +
  annotate("label", x = 4, y = -0.75, label = "Beginn", hjust = "center",
           fill = cbb_pal[6], alpha = 0.25, fontface = 2) +
  annotate("label", x = 18, y = -0.75, label = "Abgabe", hjust = "center",
           fill = cbb_pal[6], alpha = 0.25, fontface = 2) +
  annotate("label", x = 0, y = -1, label = "Beginn\nEinarbeitung", hjust = "center",
           fill = cbb_pal[2], alpha = 0.25) +
  annotate("label", x = 8, y = -1, label = "Zwischenpräsentation\n10 Power Point Folien", hjust = "center",
           fill = cbb_pal[2], alpha = 0.25) +
  annotate("label", x = 22, y = -1, label = "Abschlusskolloquium\n~20 Power Point Folien", hjust = "center",
           fill = cbb_pal[2], alpha = 0.25) +
  ylim(c(-2, 0.5)) +
  theme(legend.text = element_text(size = 14),
        legend.title = element_text(size = 14, face = 2),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.text.x = element_text(size = 14),        
        plot.title = element_text(size = 17),
        plot.subtitle = element_text(size = 12, face = "italic"),
        plot.caption = element_text(size = 12),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        legend.position = "top")


p2 <- tibble(x = c(0, 4, 8, 13, 18, 22),
             y = c(NA, 0, 18, 40, 60, NA),
             label = c(NA, "0 Seiten", "~20 Seiten",
                       "~40 Seiten", "~60 Seiten", NA)) |> 
  ggplot(aes(x, y)) +
  theme_minimal() +
  geom_line(color = "gray60", linewidth = 1.5) +
  geom_point(size = c(0, 3.5,2.5, 2.5,3.5, 0),) +
  geom_label(aes(label = label, y = y + 12.5),
             fill = cbb_pal[4], alpha = 0.25) +
  scale_x_continuous(breaks = c(0, 4, 8, 13, 18, 22),
                     labels = c("","0 Woche", "4 Woche",
                                "8 Woche", "12 Woche", ""),
                     limits = c(-1, 24),
                     name = "Zeitlicher Ablauf [Wochen]") +
  scale_y_continuous(name = "Seitenanzahl",
                     breaks = c(0, 20, 40, 60, 80, 100),
                     limits = c(NA, 75))  +
  theme(legend.text = element_text(size = 14),
        legend.title = element_text(size = 14, face = 2),
        axis.text.y = element_blank(), 
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),     
        plot.title = element_text(size = 17),
        plot.subtitle = element_text(size = 12, face = "italic"),
        plot.caption = element_text(size = 12),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        legend.position = "top")
