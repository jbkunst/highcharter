UKvisits <- data.frame(
  origin = c("France", "Germany", "USA", "Irish Republic", "Netherlands", "Spain", "Italy",
             "Poland", "Belgium", "Australia",  "Other countries", rep("UK", 5)),
  visit = c(rep("UK", 11), "Scotland", "Wales", "Northern Ireland",  "England", "London"),
  weights = c(c(12,10,9,8,6,6,5,4,4,3,33)/100*31.8,  c(2.2,0.9,0.4,12.8,15.5)))

highchartzero() %>% 
  hc_add_series(
    UKvisits, 
    "networkgraph",
    hcaes(from = origin, to = visit, weight = weights),
    layoutAlgorithm = list(enableSimulation = TRUE)
    ) %>% 
  hc_add_dependency("modules/networkgraph.js")


# example 2 ---------------------------------------------------------------
library(igraphdata)
# data(package = "igraphdata")

data(karate, package = "igraphdata")

df <- igraph::as_data_frame(karate, what = "edges")

str(df)

highchartzero() %>% 
  hc_add_series(
    df, 
    "networkgraph",
    hcaes(from = from, to = to, weight = weight),
    layoutAlgorithm = list(enableSimulation = TRUE)
  ) %>% 
  hc_add_dependency("modules/networkgraph.js")


# example 3 ---------------------------------------------------------------
highchartzero() %>%
  hc_add_dependency(name = 'modules/networkgraph.js') %>%
  hc_chart(type = 'networkgraph') %>%
  hc_title(text = 'The Indo-European Language Tree') %>%
  hc_subtitle(text = 'A Force-Directed Network Graph in Highcharts') %>%
  hc_plotOptions(networkgraph = list(
    keys = c('from', 'to'),
    layoutAlgorithm = list(enableSimulation =  TRUE, friction = -0.9)
  )) %>%
  hc_add_series(
    dataLabels = list(enabled = TRUE, linkFormat = ''),
    id = 'lang-tree',
    data = list(
      c('Proto Indo-European', 'Balto-Slavic'),
      c('Proto Indo-European', 'Germanic'),
      c('Proto Indo-European', 'Celtic'),
      c('Proto Indo-European', 'Italic'),
      c('Proto Indo-European', 'Hellenic'),
      c('Proto Indo-European', 'Anatolian'),
      c('Proto Indo-European', 'Indo-Iranian'),
      c('Proto Indo-European', 'Tocharian'),
      c('Indo-Iranian', 'Dardic'),
      c('Indo-Iranian', 'Indic'),
      c('Indo-Iranian', 'Iranian'),
      c('Iranian', 'Old Persian'),
      c('Old Persian', 'Middle Persian'),
      c('Indic', 'Sanskrit'),
      c('Italic', 'Osco-Umbrian'),
      c('Italic', 'Latino-Faliscan'),
      c('Latino-Faliscan', 'Latin'),
      c('Celtic', 'Brythonic'),
      c('Celtic', 'Goidelic'),
      c('Germanic', 'North Germanic'),
      c('Germanic', 'West Germanic'),
      c('Germanic', 'East Germanic'),
      c('North Germanic', 'Old Norse'),
      c('North Germanic', 'Old Swedish'),
      c('North Germanic', 'Old Danish'),
      c('West Germanic', 'Old English'),
      c('West Germanic', 'Old Frisian'),
      c('West Germanic', 'Old Dutch'),
      c('West Germanic', 'Old Low German'),
      c('West Germanic', 'Old High German'),
      c('Old Norse', 'Old Icelandic'),
      c('Old Norse', 'Old Norwegian'),
      c('Old Norwegian', 'Middle Norwegian'),
      c('Old Swedish', 'Middle Swedish'),
      c('Old Danish', 'Middle Danish'),
      c('Old English', 'Middle English'),
      c('Old Dutch', 'Middle Dutch'),
      c('Old Low German', 'Middle Low German'),
      c('Old High German', 'Middle High German'),
      c('Balto-Slavic', 'Baltic'),
      c('Balto-Slavic', 'Slavic'),
      c('Slavic', 'East Slavic'),
      c('Slavic', 'West Slavic'),
      c('Slavic', 'South Slavic'),
      c('Proto Indo-European', 'Phrygian'),
      c('Proto Indo-European', 'Armenian'),
      c('Proto Indo-European', 'Albanian'),
      c('Proto Indo-European', 'Thracian'),
      c('Tocharian', 'Tocharian A'),
      c('Tocharian', 'Tocharian B'),
      c('Anatolian', 'Hittite'),
      c('Anatolian', 'Palaic'),
      c('Anatolian', 'Luwic'),
      c('Anatolian', 'Lydian'),
      c('Iranian', 'Balochi'),
      c('Iranian', 'Kurdish'),
      c('Iranian', 'Pashto'),
      c('Iranian', 'Sogdian'),
      c('Old Persian', 'Pahlavi'),
      c('Middle Persian', 'Persian'),
      c('Hellenic', 'Greek'),
      c('Dardic', 'Dard'),
      c('Sanskrit', 'Sindhi'),
      c('Sanskrit', 'Romani'),
      c('Sanskrit', 'Urdu'),
      c('Sanskrit', 'Hindi'),
      c('Sanskrit', 'Bihari'),
      c('Sanskrit', 'Assamese'),
      c('Sanskrit', 'Bengali'),
      c('Sanskrit', 'Marathi'),
      c('Sanskrit', 'Gujarati'),
      c('Sanskrit', 'Punjabi'),
      c('Sanskrit', 'Sinhalese'),
      c('Osco-Umbrian', 'Umbrian'),
      c('Osco-Umbrian', 'Oscan'),
      c('Latino-Faliscan', 'Faliscan'),
      c('Latin', 'Portugese'),
      c('Latin', 'Spanish'),
      c('Latin', 'French'),
      c('Latin', 'Romanian'),
      c('Latin', 'Italian'),
      c('Latin', 'Catalan'),
      c('Latin', 'Franco-ProvenÃ§al'),
      c('Latin', 'Rhaeto-Romance'),
      c('Brythonic', 'Welsh'),
      c('Brythonic', 'Breton'),
      c('Brythonic', 'Cornish'),
      c('Brythonic', 'Cuymbric'),
      c('Goidelic', 'Modern Irish'),
      c('Goidelic', 'Scottish Gaelic'),
      c('Goidelic', 'Manx'),
      c('East Germanic', 'Gothic'),
      c('Middle Low German', 'Low German'),
      c('Middle High German', '(High) German'),
      c('Middle High German', 'Yiddish'),
      c('Middle English', 'English'),
      c('Middle Dutch', 'Hollandic'),
      c('Middle Dutch', 'Flemish'),
      c('Middle Dutch', 'Dutch'),
      c('Middle Dutch', 'Limburgish'),
      c('Middle Dutch', 'Brabantian'),
      c('Middle Dutch', 'Rhinelandic'),
      c('Old Frisian', 'Frisian'),
      c('Middle Danish', 'Danish'),
      c('Middle Swedish', 'Swedish'),
      c('Middle Norwegian', 'Norwegian'),
      c('Old Norse', 'Faroese'),
      c('Old Icelandic', 'Icelandic'),
      c('Baltic', 'Old Prussian'),
      c('Baltic', 'Lithuanian'),
      c('Baltic', 'Latvian'),
      c('West Slavic', 'Polish'),
      c('West Slavic', 'Slovak'),
      c('West Slavic', 'Czech'),
      c('West Slavic', 'Wendish'),
      c('East Slavic', 'Bulgarian'),
      c('East Slavic', 'Old Church Slavonic'),
      c('East Slavic', 'Macedonian'),
      c('East Slavic', 'Serbo-Croatian'),
      c('East Slavic', 'Slovene'),
      c('South Slavic', 'Russian'),
      c('South Slavic', 'Ukrainian'),
      c('South Slavic', 'Belarusian'),
      c('South Slavic', 'Rusyn')
    )
  ) %>%
  hc_exporting(enabled = TRUE)


