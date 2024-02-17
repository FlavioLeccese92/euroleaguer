# ConstructCourt
# Curtesy of https://github.com/solmos/eurolig/blob/5a6e10ca793649a570b76db813f8d9c533cb3904/R/plotShotchart.R

ConstructCourt = function() {
  outer_lines = tibble(
    x = c(-7.5, -7.5, 7.5, 7.5, -7.5),
    y = c(0, 14, 14, 0, 0),
    type = "Outer lines"
  )

  paint = tibble(
    x = c(-2.45, -2.45, 2.45, 2.45),
    y = c(0, 5.8, 5.8, 0),
    type = "Paint"
  )

  ft_circle = tibble(
    ConstructArc(x0 = 0, y0 = 5.8, r = 1.8, start = 0, stop = pi),
    type = "FT circle"
  )

  upper_arc3 = tibble(
    ConstructArc(x0 = 0, y0 = 1.575, r = 6.75, start = 0, stop = pi),
    type = "Upper arc"
  ) %>% filter(abs(.data$x) <= 6.6)

  y_max_corner = min(upper_arc3$y)
  left_corner3 = tibble(
    x = c(-6.6, -6.6),
    y = c(0, y_max_corner),
    type = "Left corner 3"
  )
  right_corner3 = tibble(
    x = c(6.6, 6.6),
    y = c(y_max_corner, 0),
    type = "Right corner 3"
  )
  arc3 = rbind(right_corner3, upper_arc3, left_corner3)

  backboard = tibble(
    x = c(-0.9, 0.9),
    y = c(1.2, 1.2),
    type = "backboard"
  )

  rim = ConstructArc(x0 = 0, y0 = 1.575, r = 0.225,
                     start = 0, stop = 2 * pi) %>%
    cbind(type = "rim") %>%
    as_tibble()

  semi_circle = tibble(
    ConstructArc(0, 1.575, r = 1.25, 0, pi),
    type = "semi_circle"
  )
  semi_circle_left = tibble(
    x = c(-1.25, -1.25),
    y = c(1.575, 1.2),
    type = "semi_circle_left"
  )
  semi_circle_right = tibble(
    x = c(1.25, 1.25),
    y = c(1.575, 1.2),
    type = "semi_circle_right"
  )
  restricted_area = rbind(semi_circle_right, semi_circle, semi_circle_left)

  Court = bind_rows(
    outer_lines,
    paint,
    ft_circle,
    arc3,
    backboard,
    rim,
    restricted_area
  )
  return(Court)
}


ConstructArc = function(x0, y0, r, start, stop) {
  by = ifelse(start <= stop, 0.001, -0.001)
  theta = seq(start, stop, by)
  x = x0 + r * cos(theta)
  y = y0 + r * sin(theta)

  return(tibble(x, y))
}
