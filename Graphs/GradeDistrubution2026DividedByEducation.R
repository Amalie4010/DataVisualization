library(readxl)
library(dplyr)
library(ggplot2)

head(GradeDistrubution2026DividedByEducation)

df_long_Mundtlig <- GradeDistrubution2026DividedByEducation %>%
  filter(`Evaluation form` == "Mundtlig") %>%
  select(-`Final term grade`) %>%
  mutate(Grade = as.numeric(Grade)) %>%
  uncount(`Exam grade`)

p <- ggplot(df_long_Mundtlig,
            aes(x = Education, y = Grade, fill = Education)) +
  geom_violin() +
  theme(legend.position = "none") +
  xlab("")

print(p)

