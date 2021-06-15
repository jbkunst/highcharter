library(tidyverse)
library(rvest)



path <- function(x) paste0("https://raw.githubusercontent.com/phalt/pokeapi/master/data/v2/csv/", x)

dfpkmn <- read_csv(path("pokemon.csv")) %>%
  select(-order, -is_default) %>%
  rename(pokemon = identifier)

dfstat <- read_csv(path("stats.csv")) %>%
  rename(stat_id = id) %>%
  right_join(read_csv(path("pokemon_stats.csv")),
    by = "stat_id"
  ) %>%
  mutate(identifier = str_replace(identifier, "-", "_")) %>%
  select(pokemon_id, identifier, base_stat) %>%
  spread(identifier, base_stat) %>%
  rename(id = pokemon_id)

dftype <- read_csv(path("types.csv")) %>%
  rename(type_id = id) %>%
  right_join(read_csv(path("pokemon_types.csv")), by = "type_id") %>%
  select(pokemon_id, identifier, slot) %>%
  mutate(slot = paste0("type_", slot)) %>%
  spread(slot, identifier) %>%
  rename(id = pokemon_id)

dfegg <- read_csv(path("egg_groups.csv")) %>%
  rename(egg_group_id = id) %>%
  right_join(read_csv(path("pokemon_egg_groups.csv")), by = "egg_group_id") %>%
  group_by(species_id) %>%
  mutate(
    ranking = row_number(),
    ranking = paste0("egg_group_", ranking)
  ) %>%
  select(species_id, ranking, identifier) %>%
  spread(ranking, identifier)

# dfimg <- "https://github.com/phalt/pokeapi/tree/master/data/Pokemon_XY_Sprites" %>%
#   read_html() %>%
#   html_nodes("tr.js-navigation-item > .content > .css-truncate a") %>%
#   map_df(function(x) {
#     url <- x %>% html_attr("href")
#     data_frame(
#       id = str_extract(basename(url), "\\d+"),
#       url_image = basename(url)
#     )
#   }) %>%
#   mutate(id = as.numeric(id))

url_bulbapedia_list <- "http://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_base_stats_(Generation_VI-present)"

id <- url_bulbapedia_list %>%
  read_html(encoding = "UTF-8") %>%
  html_node("table.sortable") %>%
  html_table() %>%
  .[[1]] %>%
  as.numeric()

url_icon <- url_bulbapedia_list %>%
  read_html() %>%
  html_nodes("table.sortable img") %>%
  html_attr("src")

dficon <- data_frame(id, url_icon) %>%
  filter(!is.na(id)) %>%
  distinct(id)

dfcolor <- map_df(na.omit(unique(c(dftype$type_1, dftype$type_2))), function(t) {
  # t <- "bug"
  col <- "http://pokemon-uranium.wikia.com/wiki/Template:%s_color" %>%
    sprintf(t) %>%
    read_html() %>%
    html_nodes("span > b") %>%
    html_text()
  data_frame(type = t, color = paste0("#", col))
})

dfcolorf <- crossing(
  color_1 = dfcolor$color, color_2 = dfcolor$color,
  stringsAsFactors = FALSE
) %>%
  tbl_df() %>%
  group_by(color_1, color_2) %>%
  do({
    n <- 100
    p <- 0.25
    tibble(color_f = colorRampPalette(c(.$color_1, .$color_2))(n)[round(n * p)])
  })

# THE join
pokemon <- dfpkmn %>%
  left_join(dftype, by = "id") %>%
  left_join(dfstat, by = "id") %>%
  left_join(dfcolor %>% rename(type_1 = type, color_1 = color), by = "type_1") %>%
  left_join(dfcolor %>% rename(type_2 = type, color_2 = color), by = "type_2") %>%
  left_join(dfcolorf, by = c("color_1", "color_2")) %>%
  left_join(dfegg, by = "species_id") %>%
  # left_join(dfimg, by = "id") %>%
  left_join(dficon, by = "id")

pokemon <- pokemon %>%
  mutate(color_f = ifelse(is.na(color_f), color_1, color_f))

usethis::use_data(pokemon, overwrite = TRUE)
