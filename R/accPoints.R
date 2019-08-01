#' accPoints
#'
#' Render a simple WebGL-accelerated scatter plot.
#' Quite useful for large datasets.
#'
#' Use this function as the first parameter for renderAccPoints.
#'
#' @import htmlwidgets
#'
#' @export
accPoints <- function(x, y, xlim, ylim, col, width = NULL, height = NULL, elementId = NULL) {

  cc <- grDevices::col2rgb(col, alpha=T)

  #TODO: R spends literal millenia on encoding this data to JSON.
  #      Invent a way to transfer partial results or to stringify this manually.
  #      
  #      For comparison, with 1M points this takes around 10 seconds (on my
  #      laptop); Firefox&Chrome decode the encoded JSON (which is in fact
  #      harder than encoding!) in around 0.01s.

  data = list(
    x=x,
    y=y,
    xlim=xlim,
    ylim=ylim,
    r=cc['red',],
    g=cc['green',],
    b=cc['blue',],
    a=cc['alpha',]
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'accPoints',
    data,
    width = width,
    height = height,
    package = 'shinyAccPoints',
    elementId = elementId
  )
}

#' Shiny bindings for accPoints
#'
#' Output and render functions for using accPoints within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a accPoints
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name accPoints-shiny
#'
#' @export
accPointsOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'accPoints', width, height, package = 'shinyAccPoints')
}

#' @rdname accPoints-shiny
#' @export
renderAccPoints <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, accPointsOutput, env, quoted = TRUE)
}
