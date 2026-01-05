
#SETUP & LIBRARIES

install.packages("readxl")
install.packages("tidyverse")
library(readxl)
library(tidyverse)

# LOAD DATA 
df_countries <- read_excel("repartitionentreprisesetrangereparpays.xls", skip = 0)
df_jobs <- read_excel("emploientreprisesetrangere.xls", skip = 0)

#CLEAN DATA

final_map_data <- df_countries %>%
  rename(Sector = 1) %>%
  filter(!is.na(Sector)) %>%
  filter(Sector != "Total") %>%
  mutate(Sector = trimws(Sector)) %>% 
  pivot_longer(cols = -Sector, names_to = "Country", values_to = "Companies") %>%
  # KEEP ONLY DIGITS (0-9). Deletes spaces, text, symbols.
  mutate(Companies = as.numeric(gsub("[^0-9]", "", Companies)))

# Clean Jobs Data
final_jobs_data <- df_jobs %>%
  rename(Sector = 1) %>%
  select(Sector, `Totalement Exportatrices`, AUTRE) %>%
  filter(!is.na(Sector)) %>%
  filter(Sector != "Total") %>%
  mutate(Sector = trimws(Sector)) %>%
  pivot_longer(cols = -Sector, names_to = "Company_Type", values_to = "Jobs") %>%
  # KEEP ONLY DIGITS (0-9). 
  mutate(Jobs = as.numeric(gsub("[^0-9]", "", Jobs)))

# MERGE
stats_data <- final_map_data %>%
  group_by(Sector) %>%
  summarise(Total_Companies = sum(Companies, na.rm = TRUE)) %>%
  left_join(
    final_jobs_data %>% group_by(Sector) %>% summarise(Total_Jobs = sum(Jobs, na.rm = TRUE)),
    by = "Sector"
  )

#VERIFY DATA
print("DATA PREVIEW")
print(head(stats_data))



#Mean & Median
print(paste("Mean Jobs:", round(mean(stats_data$Total_Jobs, na.rm = TRUE), 2)))
print(paste("Median Jobs:", round(median(stats_data$Total_Jobs, na.rm = TRUE), 2)))

#Shapiro-Wilk Test (Normality)
tryCatch({
  print("Shapiro-Wilk Test:")
  print(shapiro.test(stats_data$Total_Jobs))
}, error = function(e) { print("Shapiro Test Error: Data might still be constant or too small.") })

#Correlation
cor_result <- cor(stats_data$Total_Companies, stats_data$Total_Jobs, use = "complete.obs")
print(paste("Correlation Coefficient:", round(cor_result, 4)))

#Linear Regression
model <- lm(Total_Jobs ~ Total_Companies, data = stats_data)
print("Linear Regression Summary:")
print(summary(model))

#Plot
ggplot(stats_data, aes(x = Total_Companies, y = Total_Jobs)) +
  geom_point(color = "darkblue", size = 3) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  theme_minimal() +
  labs(title = "Final Model: Investment vs Jobs", x = "Companies", y = "Jobs")