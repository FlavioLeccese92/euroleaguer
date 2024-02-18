
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

CompetitionStandings = CompetitionStandings %>%
  left_join(Teams %>% select(TeamCode, PrimaryColor, SecondaryColor),
            by = "TeamCode") %>%
  left_join(CompetitionStandings %>% filter(Round == MaxRound) %>%
              arrange(desc(Position)) %>%
              mutate(y = factor(glue("#{Position} {TeamName}"),
                                levels = glue("#{Position} {TeamName}"))) %>%
              select(TeamCode, y, Position),
            by = "Position") %>%
  filter(Round %in% (MaxRound - 10):MaxRound) %>%
  mutate(x = ifelse(Round == MaxRound, Round + 0*(Position %% 2)/5, Round))

LastRound = CompetitionStandings %>% filter(Round == MaxRound)
PreviousRounds = CompetitionStandings %>% filter(Round < MaxRound)

# Create dataset for images
TeamImage = CompetitionStandings %>%
  slice_max(order_by = Round) %>%
  filter(!is.na(TeamImagesCrest)) %>%
  distinct(x, y, TeamName, TeamImagesCrest)

# e =
 CompetitionStandings %>%
  ggplot(aes(x = x, y = y)) +
  geom_smooth(aes(colour = SecondaryColor, group = TeamName), linewidth = 1.25, se = FALSE, span = 0.25) +
  geom_smooth(aes(colour = PrimaryColor, group = TeamName), linetype = "longdash", linewidth = 1.25, se = FALSE, span = 0.25) +
  geom_point(data = PreviousRounds, aes(colour = PrimaryColor), size = 3) +
  geom_point(data = PreviousRounds, colour =  "#f2f2f2", size = 1) +
  geom_point(data = LastRound, aes(colour = PrimaryColor), size = 12) +
  geom_point(data = LastRound, colour =  "#f2f2f2", size = 10) +
  geom_image(data = TeamImage, aes(y = y, image = TeamImagesCrest), size = 0.03,
             image_fun = function(img) { magick::image_crop(img) }) +
  scale_colour_identity() +
  scale_y_discrete(position = "right") +
  scale_x_continuous(breaks = 1:MaxRound, labels = 1:MaxRound,
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
    axis.title.y = element_blank(),
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
  ) +
  labs(title = PlotTitle, subtitle = PlotSubtitle, caption = PlotCaption,
       x = "", y = "")

ggsave("team-standings-race.png", plot = e, path = "figures/",
       height = 2000, width = 4100, units = "px", dpi = 200)
