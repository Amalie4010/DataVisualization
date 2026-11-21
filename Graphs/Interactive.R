
Try to make interactive barchart:
  ```{r, echo=FALSE}
# Make sure years are characters
data_long$Year <- as.character(data_long$Year)

# Get all available years
years <- sort(unique(data_long$Year))

# Create an empty Plotly chart
p <- plot_ly()

# Add one bar chart for each year
for (yr in years) {
  
  data_selected <- data_long %>%
    filter(Year == yr)
  
  p <- p %>%
    add_bars(
      data = data_selected,
      x = ~Education,
      y = ~Grade,
      name = yr,
      visible = (yr == "2026")
    )
}

# Create dropdown menu
buttons <- lapply(seq_along(years), function(i) {
  
  visibility <- rep(FALSE, length(years))
  visibility[i] <- TRUE
  
  list(
    method = "update",
    args = list(
      list(visible = visibility),
      list(title = paste("Average exam results in", years[i]))
    ),
    label = years[i]
  )
})

# Display chart
p %>%
  layout(
    title = "Average exam results in 2026",
    xaxis = list(
      title = "Education type"
    ),
    yaxis = list(
      title = "Average exam result",
      range = c(5, 8)
    ),
    updatemenus = list(
      list(
        type = "dropdown",
        buttons = buttons,
        direction = "down",
        x = 1,
        y = 1.2
      )
    ),
    showlegend = FALSE
  )
```

Another one:
  ```{r, echo=FALSE}

# Create the interactive chart
p <- p %>%
  layout(
    title = paste("Average exam results in", years[1]),
    xaxis = list(
      title = "Education type"
    ),
    yaxis = list(
      title = "Average exam result",
      range = c(5, 8),
      autorange = FALSE
    ),
    showlegend = FALSE
  )

# Convert years to JavaScript
years_js <- jsonlite::toJSON(years, auto_unbox = FALSE)

# Add navigation arrows
js_code <- sprintf("
function(el, x) {

  var years = %s;
  var currentYear = years.indexOf('2026');
  if (currentYear < 0) currentYear = 0;

  var gd = el;

  var container = document.createElement('div');
  container.style.display = 'flex';
  container.style.alignItems = 'center';
  container.style.justifyContent = 'center';
  container.style.gap = '20px';
  container.style.margin = '10px';

  var prev = document.createElement('button');
  prev.innerHTML = '&#8592;';
  prev.style.fontSize = '24px';

  var next = document.createElement('button');
  next.innerHTML = '&#8594;';
  next.style.fontSize = '24px';

  var label = document.createElement('span');
  label.style.fontSize = '18px';
  label.style.fontWeight = 'bold';

  function updateChart() {

    var visibility = years.map(function(y, i) {
      return i === currentYear;
    });

    Plotly.restyle(gd, 'visible', visibility);

    Plotly.relayout(gd, {
      title: 'Average exam results in ' + years[currentYear]
    });

    label.innerHTML = years[currentYear];

    prev.disabled = currentYear === 0;
    next.disabled = currentYear === years.length - 1;
  }

  prev.onclick = function() {
    if (currentYear > 0) {
      currentYear--;
      updateChart();
    }
  };

  next.onclick = function() {
    if (currentYear < years.length - 1) {
      currentYear++;
      updateChart();
    }
  };

  container.appendChild(prev);
  container.appendChild(label);
  container.appendChild(next);

  el.parentNode.insertBefore(container, el);

  updateChart();
}
", years_js)

htmlwidgets::onRender(p, htmlwidgets::JS(js_code))
```
