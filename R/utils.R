# S3 Method to get  layer
getLayer <- function(x, ...){
  UseMethod('getLayer')
}

getLayer.formula <- function(x, data, ...){
  fml = lattice::latticeParseFormula(x, data = data)
  if (length(fml$left.name) > 0){
    data[[fml$left.name]] = fml$left
  }
  data[[fml$right.name]] = fml$right
  params_ = modifyList(list(...), list(x = fml$right.name,
                                       y = fml$left.name, data = data, facet = names(fml$condition)
  ))
  fixLayer(params_)
}

getLayer.default <- function(x, y, data, ...){
  params_ = list(x = x, y = y, data = data, ...)
  fixLayer(params_)
}

# Fix an incomplete layer by adding relevant summaries and modifying the data
fixLayer <- function(params_){
  if (length(params_$y) == 0){
    variables = c(params_$x, params_$group)
    params_$data = plyr::count(params_$data, variables[variables != ""])
    params_$y = 'freq'
  }
  return(params_)
}

`%||%` <- function(x, y){
  if (is.null(x)) y else x
}

is.formula <- function(x){
  inherits(x, "formula")
}


rscale = function(x, to = c(0, 1), from = range(x, na.rm = TRUE)){
  (x - from[1])/diff(from) * diff(to) + to[1]
}
