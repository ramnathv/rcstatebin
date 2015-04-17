#' Create interactive statebin maps from R
#'
#' This function allows one to create interactive statebin maps from R.
#'
#' @import htmlwidgets
#'
#' @export
statebin <- function(data,
  x,
  y = if (is.formula(x)) NULL else 'y',
  control = NULL,
  colors = NULL,
  heading = "<b>Statebins</b>",
  footer = "<small>This is a statebin</small>",
  width = NULL, height = NULL, ...) {


  # forward options using x
  opts = getLayer(x = x, y = y, data = data, ...)
  opts = modifyList(opts, list(control = control,
   heading = heading, footer = footer, colors = colors, ...
  ))
  x = list(
    data = data, opts = Filter(Negate(is.null), opts)
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'statebin',
    x,
    width = width,
    height = height,
    package = 'rcstatebin'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
statebinOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'statebin', width, height, package = 'rcstatebin')
}

#' Widget render function for use in Shiny
#'
#' @export
renderStatebin <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, statebinOutput, env, quoted = TRUE)
}
