library(tidyverse)
library(rvest)

# bulbapedia --------------------------------------------------------------
bulbapedia_html <- "https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_base_stats_(Generation_VIII-present)" %>% 
  read_html(encoding = "UTF-8")

dfpkmn <- bulbapedia_html %>%
  html_node("table.sortable") %>%
  html_table() 
  
dfpkmn <- janitor::remove_constant(dfpkmn)

nms <- names(dfpkmn) %>% 
  ifelse(. == "#", "id", .) %>% 
  str_replace_all("Sp. ", "special_") %>% 
  stringi::stri_trans_general("Latin-ASCII") %>% 
  str_to_lower()

dfpkmn <- set_names(dfpkmn, nms)

pkmn_icon_url <- bulbapedia_html %>%
  html_nodes("table.sortable img") %>%
  html_attr("src")

pkmn_detail_url <- bulbapedia_html %>%
  html_nodes("table.sortable .plainlinks > a") %>%
  html_attr("href")
  
library(furrr)
plan(multiprocess(workers = 10))

dfpkmn_detail <- furrr::future_map_dfr(
  pkmn_detail_url,
  function(url = "/wiki/Rattata_(Pok%C3%A9mon)"){
    
    message(url)
    # url <- "/wiki/Necrozma_(Pokémon)"
    
    pkmn_html <- read_html(paste0("https://bulbapedia.bulbagarden.net", url))
    
    pkmn_image_url <-  pkmn_html %>% 
      html_node("img[width=\"250\"]") %>% 
      html_attr("src")
    
    pkmn_alt_images_url <- pkmn_html %>% 
      html_nodes("img[width=\"110\"]") %>% 
      html_attr("src") %>% 
      unique() %>% 
      list()
    
    pkmn_color <- pkmn_html %>% 
      html_nodes("span") %>% 
      html_attr("style") %>% 
      str_subset("border-radius: 3px") %>% 
      str_extract("#[a-zA-z0-9]{6}")
    
    tibble(
      color = pkmn_color,
      detail_url = url,
      image_url = pkmn_image_url,
      image_alt_urls = pkmn_alt_images_url
      )
    
    }, .progress = TRUE)

dfpkmn_detail

dfpkmn <- dfpkmn %>% 
  bind_cols(dfpkmn_detail) %>% 
  mutate(icon_url = pkmn_icon_url)


ids <- dfpkmn %>% 
  pull(image_alt_urls) %>% 
  map_int(length) %>% 
  {which(. == 4)}

dfpkmn %>% 
  filter(row_number() %in% ids) %>% 
  glimpse() %>% 
  distinct(id, .keep_all = TRUE)

glimpse(dfpkmn)

# pokeapi -----------------------------------------------------------------
path <- function(x) paste0("https://raw.githubusercontent.com/PokeAPI/pokeapi/master/data/v2/csv/", x)

dfpkmn2 <- read_csv(path("pokemon.csv")) %>%
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

dfcolor <- map_df(na.omit(unique(c(dftype$type_1, dftype$type_2))), function(t) {
  # t <- "bug"
  col <- "http://pokemon-uranium.wikia.com/wiki/Template:%s_color" %>%
    sprintf(t) %>%
    read_html() %>%
    html_nodes("span > b") %>%
    html_text()
  tibble(type = t, color = paste0("#", col))
})

dfcolorf <- crossing(
  color_1 = dfcolor$color, color_2 = dfcolor$color,
  stringsAsFactors = FALSE
) %>%
  group_by(color_1, color_2) %>%
  do({
    n <- 100
    p <- 0.25
    tibble(color_f = colorRampPalette(c(.$color_1, .$color_2))(n)[round(n * p)])
  })

dfcolorf <- dfcolorf %>% 
  rename(
    type_1_color = color_1,
    type_2_color = color_2,
    type_mix_color = color_f
    )

# THE JOIN
dfpkmn2 <- dfpkmn2 %>%
  left_join(dftype, by = "id") %>%
  left_join(dfstat, by = "id") %>%
  left_join(dfcolor %>% rename(type_1 = type, type_1_color = color), by = "type_1") %>%
  left_join(dfcolor %>% rename(type_2 = type, type_2_color = color), by = "type_2") %>%
  left_join(dfcolorf, by = c("type_1_color", "type_2_color")) %>%
  left_join(dfegg, by = "species_id")

dfpkmn2 <- dfpkmn2 %>% 
  mutate(type_mix_color = ifelse(is.na(type_mix_color), type_1_color, type_mix_color))

glimpse(dfpkmn2)

# final join --------------------------------------------------------------
dfpkmn  <- dfpkmn  %>% distinct(id, .keep_all = TRUE)
dfpkmn2 <- dfpkmn2 %>% distinct(id, .keep_all = TRUE) %>% 
  semi_join(dfpkmn, by = "id")

dfpkmn  <- dfpkmn  %>% select(id, pokemon, color, contains("_url"))
dfpkmn2 <- dfpkmn2 %>% select(-pokemon)

pokemon <- full_join(dfpkmn2, dfpkmn, by = "id")

pokemon <- pokemon %>% 
  select(id, pokemon, everything())
 
glimpse(pokemon)

usethis::use_data(pokemon, overwrite = TRUE)
