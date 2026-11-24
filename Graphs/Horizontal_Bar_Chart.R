# Convert the table, so that ggplot can read it properly

data_long <- studentsStudycourse %>%
  pivot_longer(
    cols = -c(Uddannelsesymbol, Retning),
    names_to = "Year",
    values_to = "Students"
  ) %>%
  filter(!is.na(Students)) %>%
  mutate(Course = paste(Uddannelsesymbol, "–", Retning))

head(data_long)

# print(data_long)

# Making the graph
data_2026 <- data_long %>%
  filter(Year == "2026")

chart_2026 <- ggplot(data_2026, aes(x = Students, y = reorder(Course, Students))) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Number of students in 2026 divided by study course",
    x = "Number of students",
    y = "Study course"
  ) +
  theme_minimal()

print(chart_2026)