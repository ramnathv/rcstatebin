## State Bin

This is an alpha version of tool to create interactive state bin maps. It has an R API as well as a javascript API.

## Installation

You can install `rcstatebin` from github. 

```r
install_github(c('ramnathv/htmlwidgets', 'ramnathv/rcstatebin'))
```

## Usage

Let us start by recreating some analysis done by http://fivethirtyeight.com on where states get their taxes from. You can create an interactive statebin chart with just one line of code, using the formula interface.

```{r eval = F}
library(rcstatebin)
statebin(taxdata, share ~ state | description, control = 'dropdown')
```

Alternately, you can also use a more traditional syntax.


```{r}
library(rcstatebin)
statebin(data = taxdata,
  x = "state",
  y = "share",
  facet = "description",
  heading =  "<b>Where do your state's taxes come from?</b>",
  footer = "<small>Source: Census <a href='http://www2.census.gov/govs/statetax/14staxcd.txt'>(Data)</a>",
  colors = RColorBrewer::brewer.pal(5, 'PuRd'),
  control = 'dropdown'
)
```

![gif](http://g.recordit.co/FVjqJddzvs.gif)

If you prefer hexagons instead of rectangles, you can pass `type = "hex"`.

```r
statebin(taxdata, share ~ state | description, control = 'dropdown', type = "hex")
```

![gif2](http://g.recordit.co/Pcio3gY70I.gif)


## Javascript API

I built `d3statebin` using a modular approach following the reusable chart guidelines outlined by [Mike Bostock](http://bost.ocks.org/mike/chart/)

```js
mystatemap = statemap()
  .x("state")
  .y("share")
  .facet("description")
  
d3.select(el)
  .datum(x.data)
  .call(mystatemap)
```


## References

Thanks are due to all these folks below, for building great components were used to create `d3statebin`

1. [Mike Bostock] for [D3.js](http://d3js.org)
2. [Elijah Meeks] for [d3.svg.legend](https://github.com/emeeks/d3-svg-legend)
3. [Gregor Aisch] for [d3-jetpack](https://github.com/gka/d3-jetpack)
4. [Justin Palmer](Justin Palmer) for [d3-tip](https://github.com/Caged/d3-tip)
