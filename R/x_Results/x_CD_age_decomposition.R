
# Data

od <- readRDS("../../Data/estimates/CD_0_100.RDS")
id <- readRDS("../../Data/estimates/CD_0_4.RDS")

df <- bind_rows(
  od %>% mutate(measure = "od")
  , id %>% mutate(measure = "id")
)



# 0. Plotting params ----

lower_year <- 1950
upper_year <- 2000

point_br <- c(seq(lower_year, upper_year, 10) , upper_year)
col_lab <- ""
age_br <- c(seq(5, 100, 20), 100)

ylab <- "Number of infants"


width <- 16
height <- 12
base_size <- 15
region_line_size <- 0.6
point_size <- 3.5

# cons <- "afghanistan"
cons <- c("niger", "guatemala", "sweden", "malawi")

df %>% 
  filter(country %in% cons) %>% 
  filter(cohort == 1950) %>% 
  ggplot(aes(x = age, y = value, group = measure, colour = measure)) +
  geom_line() +
  facet_wrap(country ~ .) +
  theme_bw()

ggsave(paste0("fig2.pdf"), width = width, height = height, units = "cm")
