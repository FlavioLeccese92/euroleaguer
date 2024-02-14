
library(euroleaguer)
library(dplyr)
library(tidyr)
library(glue)
library(sysfonts)
library(ggplot2)
library(ggtext)
library(showtext)
library(ggimage)
library(geomtextpath)
library(elementalist)
Sys.setlocale(locale = "en_EN.UTF-8")

#### Import Data ####

# Add Lato font (Euroleague official font)
font_add_google("Lato", "Lato")
font_add_google("Inconsolata", "Inconsolata")

# Add Font Awesome for logos
font_add(family = "Font Awesome 6 Brands", regular = "man/figures/fa-brands-400.ttf")
showtext_opts(dpi = 200)
showtext_auto()
CompetitionRounds = getCompetitionRounds("E2023") %>%
  filter(MinGameStartDate <= Sys.Date())

CompetitionStandings = getCompetitionStandings("E2023", CompetitionRounds$Round)

Teams = getTeam("E2023", unique(CompetitionStandings$TeamCode))

# Create dataset for images
TeamImage = CompetitionStandings %>%
  slice_max(order_by = Round) %>%
  filter(!is.na(TeamImagesCrest)) %>%
  distinct(Round, TeamName, TeamImagesCrest, Position) %>%
  mutate(y = Position)

CompetitionStandings = CompetitionStandings %>%
  left_join(Teams %>% select(TeamCode, PrimaryColor), by = "TeamCode") %>%
  filter(Round %in% (max(Round) - 10):max(Round))

CompetitionStandings %>%
  ggplot(aes(x = Round, y = Position)) +
  geom_smooth(aes(colour = PrimaryColor, group = TeamName), linewidth = 1.5, se = FALSE, span = 0.25) +
  geom_point(data = . %>% filter(Round < max(.$Round)), aes(colour = PrimaryColor), size = 4) +
  geom_point(data = . %>% filter(Round < max(.$Round)), colour =  "white", size = 2) +
  geom_point(data = . %>% filter(Round == max(.$Round)), aes(colour = PrimaryColor), size = 10)+
  geom_point(data = . %>% filter(Round == max(.$Round)), colour =  "white", size = 8) +
  geom_image(data = TeamImage, aes(y = y, image = TeamImagesCrest), size = 0.03,
             image_fun = function(img) { magick::image_crop(img) }) +
  scale_colour_identity() +
  scale_y_reverse(n.breaks = length(unique(CompetitionStandings$Position)), position = "right") +
  scale_x_continuous(n.breaks = length(unique(CompetitionStandings$Round)),
                     expand = c(0.01, 0.1)) +
  theme(
    # General
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#e2e7ea"),
    plot.background = element_rect(fill = "#f2f2f2", colour = "transparent"),
    plot.margin = margin(32, 15, 8, 17),
    text = element_text(color = "#404040", family = "Lato"),
    # Axis labels
    axis.ticks = element_blank(),
    # axis.title.y = element_text(margin = margin(l = 5, r = 10)),
    axis.title.y = element_blank(),
    # axis.text.y = element_blank(),
    # axis.title.x = element_text(margin = margin(t = 10, b = 5)),
    axis.title.x = element_blank(),
    axis.text.x = element_text(vjust = 0.5),
    # Legend
    legend.background = element_blank(),
    legend.box.background = element_blank(),
    legend.key = element_blank(),
    legend.position = 'bottom',
    legend.justification = 'left',
    legend.direction = 'horizontal',
    legend.margin = margin(10, 0, 3, 0),
    legend.box.spacing = unit(0, "pt"),
    # Title, subtitle, caption
    plot.title = element_markdown(lineheight = 1, size = 24, hjust = 0, vjust = 1, margin = margin(0, 0, -20, 0)),
    plot.subtitle = element_markdown(hjust = 1, margin = margin(-30, 3, -50, 0)),
    plot.caption = element_markdown(size = 12, margin = margin(-25, 0, 0, 3)),
    plot.caption.position = "plot",
    # Facet
    strip.background = element_rect(fill = "#F47321"),
    strip.text = element_text(colour = "black", hjust = 0)
  ) # +
    # labs(title = PlotTitle, subtitle = PlotSubtitle, caption = PlotCaption,
  #     x = "", y = "")
