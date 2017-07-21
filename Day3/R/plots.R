library(tidyr)
library(dplyr)
library(highcharter)


# general-purpose scatter plot using HighCharts (via highcharter package)

scatterPlot <- function(data,
                        width = NULL,
                        height = NULL,
                        title = "",
                        subtitle = "",
                        xLabel = "x",
                        yLabel = "y",
                        xmin = NULL,
                        xmax = NULL,
                        ymin = NULL,
                        ymax = NULL,
                        series = NULL,
                        colours = NULL,
                        sizes = NULL,
                        labels = NULL,
                        showInLegend = NULL,
                        visible = NULL,
                        xLine = NULL, xLineColour = "#FF0000", xLineWidth = 2,
                        yLine = NULL, yLineColour = "#FF0000", yLineWidth = 2,
                        legendLayout = "vertical",
                        legendAlign = "right",
                        legendVerticalAlign = "middle",
                        animation = TRUE,
                        zoomType = "xy",
                        clicked = NULL,
                        exportFilename = NULL)
{
  hc <- highchart(width = width, height = height) %>%
    hc_title(text = title) %>%
    hc_subtitle(text = subtitle) %>%
    hc_chart(animation = animation, zoomType = zoomType, backgroundColor = NULL)

  if (is.null(xLine))
    hc <- hc %>% hc_xAxis(
      title = list(text = xLabel),
      min = xmin,
      max = xmax
    )
  else
    hc <- hc %>% hc_xAxis(
      title = list(text = xLabel),
      min = xmin,
      max = xmax,
      plotLines = list(list(color = xLineColour, width = xLineWidth, value = xLine))
    )

  if (is.null(yLine))
    hc <- hc %>% hc_yAxis(
      title = list(text = yLabel),
      min = ymin,
      max = ymax
    )
  else
    hc <- hc %>% hc_yAxis(
      title = list(text = yLabel),
      min = ymin,
      max = ymax,
      plotLines = list(list(color = yLineColour, width = yLineWidth, value = yLine))
    )

  if (is.null(series))
    series <- data %>% select(series) %>% distinct %>% arrange(series) %>% unlist %>% as.character

  for (i in 1:length(series))
  {
    seriesi = series[i]
    seriesData <- data %>% filter(series == seriesi) %>% select(-series) %>% list_parse
    hc <- hc %>% hc_add_series(
      data = seriesData,
      name = seriesi,
      type = "scatter",
      showInLegend = showInLegend[i],
      visible = visible[i],
      zIndex = length(series) - i + 1,
      marker = list(
        symbol = "circle",
        radius = ifelse(is.null(sizes[i]), 4, sizes[i])),
      dataLabels = list(
        enabled = seriesi %in% labels,
        format = "{point.id}",
        style = list(color = colours[i])),
      animation = animation,
      stickyTracking = FALSE)
  }

  if (!is.null(colours)) hc <- hc %>% hc_colors(colours)

  hc <- hc %>% hc_tooltip(animation = FALSE, formatter = JS("function() { return (this.point.tooltip) }"))

  if (!is.null(clicked))
  {
    fn <- paste("function() { Shiny.onInputChange('", clicked, "', this.id) }", sep = "")
    hc <- hc %>%
      hc_plotOptions(
        series = list(
          cursor = "pointer",
          point = list(
            events = list(
              click = JS(fn)
            )
          )
        )
      )
  }

  hc <- hc %>%
    hc_legend(layout = legendLayout, align = legendAlign, verticalAlign = legendVerticalAlign, floating = FALSE, borderWidth = 1)

  if (!is.null(exportFilename))
    hc <- hc %>%
    hc_exporting(enabled = TRUE, filename = exportFilename)
  
  hc
}


# density plot in which the input data is a list of numeric vectors

densityPlot <- function(data,
                        width = NULL,
                        height = NULL,
                        title = "",
                        subtitle = "",
                        xLabel = "",
                        yLabel = "density",
                        showYLabels = TRUE,
                        xmin = NULL,
                        xmax = NULL,
                        ymin = NULL,
                        ymax = NULL,
                        series = NULL,
                        colours = NULL,
                        showInLegend = NULL,
                        visible = NULL,
                        fillOpacity = NULL,
                        tooltipDigits = 1,
                        numberOfPoints = 1024,
                        legendLayout = "vertical",
                        legendAlign = "right",
                        legendVerticalAlign = "middle",
                        animation = TRUE,
                        zoomType = "x",
                        exportFilename = NULL)
{
  hc <- highchart(width = width, height = height) %>%
    hc_title(text = title) %>%
    hc_subtitle(text = subtitle) %>%
    hc_chart(animation = animation, zoomType = zoomType, backgroundColor = NULL) %>%
    hc_xAxis(title = list(text = xLabel), min = xmin, max = xmax) %>%
    hc_yAxis(title = list(text = yLabel), labels = list(enabled = showYLabels), min = ymin, max = ymax)

  type <- ifelse(is.null(fillOpacity), "spline", "areaspline")

  if (is.null(series)) series <- names(data)

  for (i in 1:length(data))
  {
    series <- names(data)[i]
    seriesData <- density(data[[i]], n = numberOfPoints)
    seriesData <- data_frame(x = seriesData$x, y = seriesData$y) %>% list_parse
    hc <- hc %>%
      hc_add_series(
        data = seriesData,
        name = series,
        type = type,
        showInLegend = showInLegend[i],
        visible = visible[i],
        animation = animation
      )
  }

  if (!is.null(colours))
    hc <- hc %>%
      hc_colors(colours)

  hc <- hc %>%
    hc_plotOptions(areaspline = list(fillOpacity = fillOpacity))

  hc <- hc %>%
    hc_legend(layout = legendLayout, align = legendAlign, verticalAlign = legendVerticalAlign, floating = FALSE, borderWidth = 1)

  hc <- hc %>%
    hc_tooltip(followPointer = TRUE, crosshairs = TRUE, formatter = JS(paste("function() { return (this.x.toFixed(", tooltipDigits, ")) }", sep = "")))

  if (!is.null(exportFilename))
    hc <- hc %>%
      hc_exporting(enabled = TRUE, filename = exportFilename)

  hc
}

