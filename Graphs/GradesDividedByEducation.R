# Convert the table, so that ggplot can read it properly

names(gradesDividedByEducation)[1] <- "Education"
data_long <- gradesDividedByEducation %>% 
  pivot_longer(
    cols = -Education,
    names_to = "Year",
    values_to = "Grade"
  )

head(data_long)

# print(data_long)

# Making the graph
data_2026 <- data_long %>%
  filter(Year == "2026")

chart_2026 <- ggplot(data_2026, aes(x = Education, y = Grade)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Grades in 2026 divided by education",
    x = "Education",
    y = "Grade"
  ) +
  theme_minimal()

print(chart_2026)
