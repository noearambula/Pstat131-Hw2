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
  step_dummy(type,one_hot = TRUE) %>%
  step_normalize(all_predictors()) %>%
  step_interact(terms = type ~ shucked_weight) %>%
  step_interact(terms = longest_shell ~ diameter) %>%
  step_interact(terms = shucked_weight ~ shell_weight)
  
abalone_recipe

# Question 4


# Question 5


# Question 6


# Question 7

  
  
  
  
  
  
  
  

  