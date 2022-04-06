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

  ## The distribution of age is a little postively skewed most of the points are centered around age 11

# Question 2

  
  
  
  
  
  
  
  
  
  
  

  