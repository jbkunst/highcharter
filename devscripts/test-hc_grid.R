hc_grid(
  hc_demo(),
  hc_demo() %>% hc_add_theme(hc_theme_ft()),
  hc_demo() %>% hc_add_theme(hc_theme_db()),
  hc_demo() %>% hc_add_theme(hc_theme_flat()),
  hc_demo() %>% hc_add_theme(hc_theme_smpl()),
  hc_demo() %>% hc_add_theme(hc_theme_economist()),
  nrow = 2, ncol = 3, widths = 3:1/6
) %>% htmltools::browsable()
