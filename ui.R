# Shared values and library statements
source("global.R")

navbarPage(
    "Chemicals in Makeup Products",

    tabPanel(
        "About",
        sidebarPanel(
            h4("Introduction"),
            helpText(
                "Nowadays, with increasing demand for cosmetics and thousands
                 of brands in the market, consumers are overwhelmed and get
                 confused about what products to choose. Our shiny app is designed
                 to present a distribution of harmful chemicals in cosmetic products
                 and gives users an interactive experience of examining number of
                 chemicals in different cosmetic subcategories."
            )
        ),
        mainPanel(
            h4("How SAFE is your cosmetics?", align = "middle"),

            img(
                src = 'cosmeticsmyths.jpg',
                height = 348,
                width = 576,
                style = "display: block; margin-left: auto; margin-right: auto;"
            )
        ),
        verticalLayout(
            "Designed by:",
            "Linfei Jing",
            "Minho Shin",
            "Xinyun Zhang",
            "@University of Illinois at Urbana-Champaign",
            "photo source:https://cdn2.ewg.org/sites/default/files/blog/cosmetics-myths.jpg"
        )
    ),
    tabPanel(
        "Original Data",
        title = "Original Cosmetic Data",
        sidebarLayout(sidebarPanel(
            conditionalPanel(
                'input.dataset === "makeup_downsample"',
                checkboxGroupInput(
                    "show_vars",
                    "Columns in cosmetic data to show:",
                    names(makeup_downsample),
                    selected = names(makeup_downsample)
                )
            )
        ),
        mainPanel(tabsetPanel(
            id = 'dataset',
            tabPanel("makeup_downsample", DT::dataTableOutput("mytable1"))
        )))
    ),


    tabPanel("Word Cloud",
             sidebarLayout(
                 # Sidebar with a slider and selection inputs
                 sidebarPanel(
                     selectInput(
                         "Subcategory",
                         "Choose a Subcategory:",
                         choices = UniqueSubCategory,
                         selected = "Blashes"
                     ),
                     sliderInput(
                         "min",
                         "Minimum Frequency:",
                         min = 1,
                         max = 6000,
                         value = 1000
                     )
                 ),
                 mainPanel(plotOutput("plot"))
             )),
    tabPanel(
        "Chemical Count Frequency",
        sidebarPanel(
            h3("Frequency of Chemical Count in Cosmetic Products"),
            verticalLayout(
                "*Plot 2: chemical counts distribution of all cosmetic products > 1",
                "*Plot 3: chemical counts distribution of cosmetic products with chemical counts > 2",
                "*Plot 4: chemical counts distribution of cosmetic products with chemical counts > 3"
            )
        ),
        mainPanel(
            h5("Plot 1"),
            plotOutput("chemical_count_all_freq"),
            h5("Plot 2"),
            plotOutput("chemical_count_freq1"),
            h5("Plot 3"),
            plotOutput("chemical_count_freq2"),
            h5("Plot 4"),
            plotOutput("chemical_count_freq3")
        )
    ),
    tabPanel(
        "Comparison in Treemap",
        sidebarPanel(
            h2("Comparison of Counts of Chemicals in Subcategories"),
            helpText(
                "The treemap demonstrates a comparison of counts of chemicals in different makeup subcategories.
                                          Specifically, we took the mean chemical counts of different subcategories and plot them on the treemap.
                                          In other words, the bigger the area, the more chemicals are in the subcategory makeup products on average."
            )
        ),
        mainPanel(plotOutput("treemap"))
    ),
    tabPanel(
        "Regression Modeling",
        sidebarPanel(
            h3("Regression model"),
            verticalLayout(
                "Model Explanation:",
                "Response variable: chemical counts",
                "Predictor variable 1: Brandname",
                "Predictor variable 2: Subcategory",
                "*Both Predictor variables are constructed as dummy variables",
                "*Regression model is constructed based on a sample size of 1000 for the ease of display"
            )
        ),
        mainPanel(verbatimTextOutput("model"))
    )
)
