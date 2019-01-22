highchart() %>% 
  hc_add_series(
    type = "treemap",
    layoutAlgorithm = "squarified",
    allowDrillToNode = TRUE,
    levels = list(
      list(
        level = 1,
        dataLabels = list(
          enabled = TRUE
        ),
        borderWidth = 3
      ),
      list(
        level = 2,
        dataLabels = list(
          enabled = TRUE
        ),
        borderWidth = 2
      )
    ),
    data = list(
      # LEVEL I
      list(
        id = "A",
        name = "apples",
        color = "#EC2500"
      ),
      list(
        id = "B",
        name = "Bananas",
        color = "#ECE100"
      ),
      # LEVEL II
      list(
        name = "Anna",
        parent = "A",
        value = 4
      ),
      list(
        name = "Anna2",
        parent = "A",
        value = 2
      ),
      list(
        id = "R",
        name = "Rick",
        parent = "B"
      ),
      list(
        id = "P",
        name = "Paul",
        parent = "B"
      ),
      # LEVEL 3
      list(
        name = "SubRick",
        parent = "R",
        value = 3
      ),
      list(
        name = "SubRick2",
        parent = "R",
        value = 3
      ),
      list(
        id = "SP",
        name = "SubPaul",
        value = 5,
        parent = "P"
      )
    )
  )
