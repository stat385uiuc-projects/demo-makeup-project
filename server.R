# Shared values and library statements
source("global.R")

# Construct the shiny server component
shinyServer(function(input, output, session) {
  data = reactive({
    if (!(input$Subcategory %in% makeup_downsample$SubCategory))
      stop("Requested category is missing from selection.")

    filename = file.path("data",
                          clean_filenames(
                            paste0("frequencies_", input$Subcategory, ".rds")
                           )
                         )
    readRDS(filename)
  })

  output$plot = renderPlot({
    wordcloud(
      words = data()$word,
      freq = data()$freq,
      random.order = FALSE,
      rot.per = 0.3,
      scale = c(4, .5),
      min.freq = input$min,
      colors = brewer.pal(8, "Dark2")
    )
  })

  output$mytable1 = DT::renderDataTable({
    DT::datatable(makeup_downsample)
  })

  output$chemical_count_all_freq = renderPlot({
    ggplot(data = counts_chem) +
      aes(x = nchem) +
      geom_bar() +
      labs(title = "Chemical Count Frequency of Cosmetic Products") +
      scale_y_continuous(
        labels = function(n) {
          format(n, scientific = FALSE)
        }
      ) +
      theme_bw() +
      theme(panel.grid.major = element_blank())
  })

  output$chemical_count_freq1 = renderPlot({
    ggplot(data = counts_chem %>% filter(nchem > 1)) +
      aes(x = nchem) +
      geom_bar() +
      labs(title = "Chemical Count Frequency of Cosmetic Products >1") +
      scale_y_continuous(
        labels = function(n) {
          format(n, scientific = FALSE)
        }
      ) +
      theme_bw() +
      theme(panel.grid.major = element_blank())
  })

  output$chemical_count_freq2 = renderPlot({
    ggplot(data = counts_chem %>% filter(nchem > 2)) +
      aes(x = nchem) +
      geom_bar() +
      labs(title = "Chemical Count Frequency of Cosmetic Products (>2)") +
      scale_y_continuous(
        labels = function(n) {
          format(n, scientific = FALSE)
        }
      ) +
      theme_bw() +
      theme(panel.grid.major = element_blank())
  })

  output$chemical_count_freq3 = renderPlot({
    ggplot(data = counts_chem %>% filter(nchem > 3)) +
      aes(x = nchem) +
      geom_bar() +
      labs(title = "Chemical Count Frequency of Cosmetic Products (>3)") +
      scale_y_continuous(
        labels = function(n) {
          format(n, scientific = FALSE)
        }
      ) +
      theme_bw() +
      theme(panel.grid.major = element_blank())
  })

  output$model = renderPrint({
    summary(model_fit)
  })

  output$treemap = renderPlot({
    ggplot(df,
           aes(
             area = mean,
             fill = subcategory,
             label = subcategory,
             subgroup = group
           )) +
      geom_treemap() +
      geom_treemap_subgroup_border() +
      geom_treemap_subgroup_text(
        place = "centre",
        grow = T,
        alpha = 0.5,
        colour =
          "black",
        fontface = "italic",
        min.size = 0
      ) +
      geom_treemap_text(colour = "white",
                        place = "topleft",
                        reflow = T)
  })
})
