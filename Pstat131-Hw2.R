# Pstat 131 Hw 2
# install.packages('ggthemes')
library(ggplot2)
library(tidyverse)
library(tidymodels)
library(corrplot)
library(ggthemes)
tidymodels_prefer()
library(readr)
abalone <- read_csv("abalone.csv")

# Question 1
new_abalone = abalone %>%
  mutate(age = (rings + 1.5))

  ## Distribution of age
ggplot(new_abalone, aes(x = age)) + geom_histogram(color = 'blue', bins = 30)

  ## The distribution of age is a little positively skewed most of the points are centered around age 11

# Question 2
set.seed(777)

abalone_split <- initial_split(new_abalone, prop = 0.80,
                                strata = age)  
abalone_train <- training(abalone_split)
abalone_test <- testing(abalone_split)
  
# Question 3
simple_abalone_recipe <- recipe(age ~ type + longest_shell + diameter + height + whole_weight + shucked_weight + viscera_weight + shell_weight, data = abalone_train)
simple_abalone_recipe

  ## we did not include rings to predict age because age is just rings + 1.5
abalone_recipe <- recipe(age ~ type + longest_shell + diameter + height + whole_weight + shucked_weight + viscera_weight + shell_weight, data = abalone_train) %>% 
  step_dummy(all_nominal_predictors()) %>%   # creates dummy variables
  step_normalize(all_predictors()) %>%    # centers and scales all predictors
  step_interact(terms = type ~ shucked_weight) %>%
  step_interact(terms = longest_shell ~ diameter) %>%
  step_interact(terms = shucked_weight ~ shell_weight)
  
abalone_recipe

# Question 4
lm_model <- linear_reg() %>% 
  set_engine("lm")

# Question 5
lm_wflow <- workflow() %>% 
  add_model(lm_model) %>% 
  add_recipe(abalone_recipe)

lm_fit <- fit(lm_wflow, abalone_train)
head(lm_fit)

# Question 6
 # variables represents the new data we will be using to predict an age
variables = data.frame(type = 'F',longest_shell = 0.50, diameter = 0.10, height = 0.30, whole_weight = 4, shucked_weight = 1, viscera_weight = 2, shell_weight = 1)
predict(lm_fit, new_data = variables)

# Question 7

  ## Creating a metric set
abalone_metrics = metric_set(rmse, rsq, mae)
  ## My predictions of the data
abalone_pred <- predict(lm_fit, new_data = abalone_train %>% select(-age))

abalone_pred = bind_cols(abalone_pred, abalone_train %>% select(age))
  
abalone_pred %>%
  head()

  ## apply your metric set to the tibble, report the results, and interpret the R^2 value.
abalone_metrics(abalone_pred, truth = age, estimate = .pred)
  
 ## the r-squared value is the goodness of fit measure and measures the
 ## relationship between my model and the dependent variable, in this case age
 ## here the r-squared value is 0.548 for my model meaning 54.8% of the variance of age was explained by my model
 ## This suggests that this model was not that great at estimating values, although still some correlation
  