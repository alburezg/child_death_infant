
# 0. Plotting params ----

lower_year <- 1950
upper_year <- 2000

point_br <- c(seq(lower_year, upper_year, 10) , upper_year)
col_lab <- ""
age_br <- c(seq(5, 100, 20), 100)

ylab <- "Number of infants"

# Choose size options depending on whether image is intended for small format.
# medium (regular draft) or large (presentation)

# 0.1. Small plotting params 
# width <- 8
# height <- 6
# base_size <- 9
# region_line_size <- 0.4
# point_size <- 1.5

# 0.2. Draft paper and presentation format (large)

width <- 16
height <- 12
base_size <- 15
region_line_size <- 0.6
point_size <- 3.5

cons <- "afghanistan"
# cons <- c("niger", "guatemala", "sweden", "malawi")

df_cl_m_full %>% 
  filter(type == "country") %>% 
  filter(country %in% cons) %>% 
  # filter(cohort %in% c(1950, 1966, 1980, 2000)) %>% 
  filter(cohort %in% seq(1950, 2000, 10)) %>% 
  mutate(
    median = value
    , region = country
    ) %>% 
  ggplot() +
  geom_line(
    aes(x = age, y = median, group = cohort, colour = cohort)
    , size = region_line_size
    , show.legend = FALSE
  ) +
  # Plot ECL shapes to help distinguish regions
  # geom_point(
  #   aes(x = age, y = median, group = region, colour = region
  #       # , size = share
  #       , shape = region
  #   )
    # , size = point_size
    # , data = . %>% filter(age %in% age_br)
  # ) +
  # Add facet numbers
  # geom_text(aes(x = x, y = y, label = label), data = f_lab, size = 6) +
  # scale_x_continuous("Woman's age") +
  scale_x_continuous("Woman's life course (age in years)") +
  scale_y_continuous(
    ylab
    , position = "left"
    , sec.axis = dup_axis()
  ) +
  scale_color_discrete(col_lab, br = regions_long, labels = regions_short) +
  scale_fill_discrete(col_lab, br = regions_long, labels = regions_short) +
  scale_shape_discrete(col_lab, br = regions_long, labels = regions_short) +
  # scale_size_continuous("Population share") +
  # facet_wrap(. ~ cohort2, scales = 'fixed') +
  # Use with four measures
  theme_bw(base_size = base_size) +
  theme(
    legend.position = "bottom"
    # Remove space over legend
    , legend.margin=margin(t=-0.25, r=0, b=0, l=0, unit="cm")
    # Remove space between legends
    , legend.key.size = unit(0.1, "cm")
    # Remove title on left
    , axis.text.y.left = element_blank()
    , axis.ticks.y.left = element_blank()
    , axis.title.y.right = element_blank()
    # get rid of facet boxes
    , strip.background = element_blank()
    # , strip.text.y = element_blank()
    # Move y axis closer to the plot
    , axis.title.y = element_text(margin = margin(t = 0, r = -2, b = 0, l = 0))
    # Remove spacing between facets
    # , panel.spacing.x=unit(0.07, "cm")
    # , panel.spacing.y=unit(0.07, "cm")
  )

# Difernet components ----


df <-
  cbind(
    # Child loss
    sum_cl2 %>% select(region, age, cohort, cl = median ) %>% 
      arrange(region, cohort, age)
    # Child survival
    , sum_cs2 %>% 
      arrange(region, cohort, age) %>% 
      select(cs = median) 
    # Survived - died
  ) %>% 
  arrange(region, cohort, age) %>% 
  mutate(born = cl+cs)

p <- df %>% 
  reshape2::melt(id = c("region","age", "cohort")) %>% 
  filter(region == "sub-saharan africa") %>% 
  filter(cohort == 1950) %>% 
  ggplot(aes(x = age, y = value, group = variable, colour = variable, linetype = variable)) +
  geom_line() +
  # facet_grid(cohort ~ .) +
  theme_bw()

ggsave(paste0("fig2.pdf"), width = width, height = height, units = "cm")
