
#' conjunto de dados pode ser acessado em:
#' https://college.cengage.com/mathematics/brase/understandable_statistics/7e/students/datasets/slr/frames/slr04.html

# Codifique uma regressão simples de uma variável -------------------------

# unemployment is loaded in the workspace
summary(unemployment)

# Define a formula to express female_unemployment as a function of male_unemployment
fmla <- female_unemployment ~ male_unemployment

# Print it
fmla

# Use the formula to fit a model: unemployment_model
unemployment_model <- lm(fmla, data = unemployment)

# Print it
unemployment_model


# Examining a model -------------------------------------------------------

# broom and sigr are already loaded in your workspace
# Print unemployment_model
unemployment_model

# Call summary() on unemployment_model to get more details
summary(unemployment_model)

# Call glance() on unemployment_model to see the details in a tidier form
broom::glance(unemployment_model)

# Call wrapFTest() on unemployment_model to see the most relevant details
sigr::wrapFTest(unemployment_model)


# Predicting from the unemployment model ----------------------------------

# unemployment is in your workspace
summary(unemployment)

# newrates is in your workspace
newrates

# Predict female unemployment in the unemployment data set
unemployment$prediction <-  predict(unemployment_model)

# load the ggplot2 package
library(ggplot2)

# Make a plot to compare predictions to actual (prediction on x axis)
ggplot(unemployment, aes(x = prediction, y = female_unemployment)) + 
  geom_point() +
  geom_abline(color = "blue")

# Predict female unemployment rate when male unemployment is 5%
pred <- predict(unemployment_model, newdata = newrates)
# Print it
pred



# Multivariate linear regression (Part 1) ---------------------------------

#' In this exercise, you will work with the blood pressure dataset:
#' https://college.cengage.com/mathematics/brase/understandable_statistics/7e/students/datasets/mlr/frames/frame.html

# bloodpressure is in the workspace
summary(bloodpressure)

# Create the formula and print it
fmla <- blood_pressure ~ age + weight
fmla

# Fit the model: bloodpressure_model
bloodpressure_model <- lm(fmla, data = bloodpressure)

# Print bloodpressure_model and call summary() 
bloodpressure_model
summary(bloodpressure_model)


# Multivariate linear regression (Part 2) ---------------------------------
# bloodpressure is in your workspace
summary(bloodpressure)

# bloodpressure_model is in your workspace
bloodpressure_model

# predict blood pressure using bloodpressure_model :prediction
bloodpressure$prediction <- predict(bloodpressure_model)

# plot the results
ggplot(bloodpressure, aes(x = prediction, y = blood_pressure)) + 
  geom_point() +
  geom_abline(color = "blue")


# Avalie graficamente o modelo de desemprego ------------------------------

# unemployment, unemployment_model are in the workspace
summary(unemployment)
summary(unemployment_model)

# Make predictions from the model
unemployment$predictions <- predict(unemployment_model, data = unemployment)

# Fill in the blanks to plot predictions (on x-axis) versus the female_unemployment rates
ggplot(unemployment, aes(x = predictions, y = female_unemployment)) + 
  geom_point() + 
  geom_abline()

# From previous step
unemployment$predictions <- predict(unemployment_model)

# Calculate residuals
unemployment$residuals <- unemployment$female_unemployment - unemployment$predictions

# Fill in the blanks to plot predictions (on x-axis) versus the residuals
ggplot(unemployment, aes(x = predictions, y = residuals)) + 
  geom_pointrange(aes(ymin = 0, ymax = residuals)) + 
  geom_hline(yintercept = 0, linetype = 3) + 
  ggtitle("residuals vs. linear model prediction")


# A curva de ganho para avaliar o modelo de desemprego --------------------

# unemployment is in the workspace (with predictions)
summary(unemployment)

# unemployment_model is in the workspace
summary(unemployment_model)

# Load the package WVPlots
library(WVPlots)

# Plot the Gain Curve
WVPlots::GainCurvePlot(unemployment, "predictions", "female_unemployment", title = "Unemployment model")



# Calculate RMSE ----------------------------------------------------------

# unemployment is in the workspace
summary(unemployment)

# For convenience put the residuals in the variable res
res <- unemployment$predictions - unemployment$female_unemployment

# Calculate RMSE, assign it to the variable rmse and print it
(rmse <- sqrt(mean(res^2)))

# Calculate the standard deviation of female_unemployment and print it
(sd_unemployment <- sd(unemployment$female_unemployment)) 



# Correlation and R_squared -----------------------------------------------

# unemployment is in your workspace
summary(unemployment)

# unemployment_model is in the workspace
summary(unemployment_model)

# Calculate mean female_unemployment: fe_mean. Print it
(fe_mean <- mean(unemployment$female_unemployment))

# Calculate total sum of squares: tss. Print it
(tss <- sum((unemployment$female_unemployment - fe_mean)^2))

# Calculate residual sum of squares: rss. Print it
(rss <- sum(unemployment$residuals^2))

# Calculate R-squared: rsq. Print it. Is it a good fit?
(rsq <- 1 - (rss/tss))

# Get R-squared from glance. Print it
str(glance(unemployment_model))

(rsq_glance <- broom::glance(unemployment_model)$r.squared)

# unemployment is in your workspace
summary(unemployment)

# unemployment_model is in the workspace
summary(unemployment_model)

# Get the correlation between the prediction and true outcome: rho and print it
(rho <- cor(unemployment$predictions,unemployment$female_unemployment))

# Square rho: rho2 and print it
(rho2 <- rho^2)

# Get R-squared from glance and print it
(rsq_glance <- glance(unemployment_model)$r.squared)


# Generating a random test/train split ------------------------------------

library(ggplot2)

# mpg data from the package ggplot2 
# The data describes the characteristics of several makes 
# and models of cars from different years.
# The goal is to predict city fuel efficiency from highway fuel efficiency.
summary(mpg) 
dim(mpg)

# Use nrow to get the number of rows in mpg (N) and print it
(N <- nrow(mpg))

# Calculate how many rows 75% of N should be and print it
# Hint: use round() to get an integer
(target <- round(0.75*N))

# Create the vector of N uniform random variables: gp
gp <- runif(N)

# Use gp to create the training set: mpg_train (75% of data) and mpg_test (25% of data)
mpg_train <- mpg[gp < 0.75,]
mpg_test <- mpg[gp >= 0.75,]

# Use nrow() to examine mpg_train and mpg_test
nrow(mpg_train)
nrow(mpg_test)


# Train a model using test/train split ------------------------------------
# mpg_train is in the workspace
summary(mpg_train)

# Create a formula to express cty as a function of hwy: fmla and print it.
(fmla <- cty ~ hwy)

# Now use lm() to build a model mpg_model from mpg_train that predicts cty from hwy 
mpg_model <- lm(fmla, data = mpg_train)

# Use summary() to examine the model
summary(mpg_model)



# Evaluate a model using test/train split ---------------------------------

# Examine the objects in the workspace
ls.str()

# predict cty from hwy for the training set
mpg_train$pred <- predict(mpg_model,mpg_train)

# predict cty from hwy for the test set
mpg_test$pred <- predict(mpg_model,mpg_test)

rmse <- function(predcol, ycol) {
  res = predcol-ycol
  sqrt(mean(res^2))
}

# Evaluate the rmse on both training and test data and print them
(rmse_train <- rmse(mpg_train$pred, mpg_train$cty))
(rmse_test <- rmse(mpg_test$pred, mpg_test$cty))

r_squared <- function(predcol, ycol) {
  tss = sum( (ycol - mean(ycol))^2 )
  rss = sum( (predcol - ycol)^2 )
  1 - rss/tss
}

# Evaluate the r-squared on both training and test data.and print them
(rsq_train <- r_squared(mpg_train$pred, mpg_train$cty))
(rsq_test <- r_squared(mpg_test$pred, mpg_test$cty))

# Plot the predictions (on the x-axis) against the outcome (cty) on the test data
ggplot(mpg_test, aes(x = pred, y = cty)) + 
  geom_point() + 
  geom_abline()



# Create a cross validation plan ------------------------------------------

# Load the package vtreat
library(vtreat)

# mpg is in the workspace
summary(mpg)

# Get the number of rows in mpg
nRows <- nrow(mpg)

# Implement the 3-fold cross-fold plan with vtreat
splitPlan <- kWayCrossValidation(234,3, NULL, NULL)

# Examine the split plan
str(splitPlan)


# Evaluate a modeling procedure using n-fold cross-validation -------------

# mpg is in the workspace
summary(mpg)

# splitPlan is in the workspace
str(splitPlan)

# Run the 3-fold cross validation plan from splitPlan
k <- 3 # Number of folds
mpg$pred.cv <- 0 
for(i in 1:k) {
  split <- splitPlan[[i]]
  model <- lm(cty ~ hwy, data = mpg[split$train, ])
  mpg$pred.cv[split$app] <- predict(model, newdata = mpg[split$app, ])
}

# Predict from a full model
mpg$pred <- predict(lm(cty ~ hwy, data = mpg))

# Get the rmse of the full model's predictions
rmse(mpg$pred, mpg$cty)

# Get the rmse of the cross-validation predictions
rmse(mpg$pred.cv, mpg$cty)


# Examining the structure of categorical inputs ---------------------------

# The dataset flowers (derived from the Sleuth3 package)
library(Sleuth3)

# Call str on flowers to see the types of each column
str(case0901)

# Use unique() to see how many possible values Time takes
unique(flowers$Time)
# [1] "Late"  "Early"

# Build a formula to express Flowers as a function of Intensity and Time: fmla. Print it
(fmla <- as.formula("Flowers ~ Intensity + Time"))

# Use fmla and model.matrix to see how the data is represented for modeling
mmat <- model.matrix(fmla, data = case0901)

# Examine the first 20 lines of flowers
case0901[1:20,] 

# Examine the first 20 lines of mmat
mmat[1:20,] 


# Modeling with categorical inputs ----------------------------------------

# flowers in is the workspace
str(case0901)

# fmla is in the workspace
fmla

# Fit a model to predict Flowers from Intensity and Time : flower_model
flower_model <- lm(fmla, data = case0901)

# Use summary on mmat to remind yourself of its structure
summary(mmat)

# Use summary to examine flower_model 
summary(flower_model)

# Predict the number of flowers on each plant
case0901$predictions <- predict(flower_model)

library(ggplot2)
# Plot predictions vs actual flowers (predictions on x-axis)
ggplot(case0901, aes(x = predictions, y = Flowers)) + 
  geom_point() +
  geom_abline(color = "blue") 







# 31.01.2022 - Interações entre variáveis ---------------------------------

#' Neste exercício, você usará interações para modelar o efeito do sexo e da 
#' atividade gástrica no metabolismo do álcool.
#' 
#' Variáveis: 
#' Metabol: a taxa de metabolismo do álcool
#' Gastric: a taxa de atividade da álcool desidrogenase gástrica
#' Sex: o sexo do bebedor (M/F)

# alcohol is in the workspace
summary(alcohol)

# Create the formula with main effects only
(fmla_add <- Metabol ~ Gastric +  Sex)

# Create the formula with interactions
(fmla_interaction <- Metabol ~  Gastric + Gastric:Sex)

# Fit the main effects only model
model_add <- lm(fmla_add,alcohol)

# Fit the interaction model
model_interaction <- lm(fmla_interaction,alcohol)

# Call summary on both models and compare
summary(model_add)
summary(model_interaction)




# -------------------------------------------------------------------------

#' Utilizando cross-validation para verificar se o modelo com interações entre
#' as variáveis é, de fato, o melhor modelo


# alcohol is in the workspace
summary(alcohol)

# Both the formulae are in the workspace
fmla_add
fmla_interaction

# Create the splitting plan for 3-fold cross validation
set.seed(34245)  # set the seed for reproducibility
splitPlan <- kWayCrossValidation(nrow(alcohol), 3, NULL, NULL)

# Sample code: Get cross-val predictions for main-effects only model
alcohol$pred_add <- 0  # initialize the prediction vector
for(i in 1:3) {
  split <- splitPlan[[i]]
  model_add <- lm(fmla_add, data = alcohol[split$train, ])
  alcohol$pred_add[split$app] <- predict(model_add, newdata = alcohol[split$app, ])
}

# Get the cross-val predictions for the model with interactions
alcohol$pred_interaction <- 0 # initialize the prediction vector
for(i in 1:3) {
  split <- splitPlan[[i]]
  model_interaction <- lm(fmla_interaction, data = alcohol[split$train, ])
  alcohol$pred_interaction[split$app] <- predict(model_interaction, newdata = alcohol[split$app, ])
}

# Get RMSE # raiz quadrada da média dos resíduos ao quadrado
alcohol %>% 
  gather(key = modeltype, value = pred, pred_add, pred_interaction) %>%
  mutate(residuals = Metabol - pred) %>%
  group_by(modeltype) %>%
  summarize(rmse = sqrt(mean(residuals^2)))





# -------------------------------------------------------------------------

#' Relative error



# fdata is in the workspace
summary(fdata)

# Examine the data: generate the summaries for the groups large and small:
fdata %>% 
  group_by(label) %>%     # group by small/large purchases
  summarize(min  = min(y),   # min of y
            mean = mean(y),   # mean of y
            max  = max(y))   # max of y

# Fill in the blanks to add error columns
fdata2 <- fdata %>% 
  group_by(label) %>%       # group by label
  mutate(residual = pred - y,  # Residual
         relerr   = residual/y)  # Relative error

# Compare the rmse and rmse.rel of the large and small groups:
fdata2 %>% 
  group_by(label) %>% 
  summarize(rmse     = sqrt(mean(residual^2)),   # RMSE
            rmse.rel = sqrt(mean(relerr^2)))   # Root mean squared relative error

# Plot the predictions for both groups of purchases
ggplot(fdata2, aes(x = pred, y = y, color = label)) + 
  geom_point() + 
  geom_abline() + 
  facet_wrap(~ label, ncol = 1, scales = "free") + 
  ggtitle("Outcome vs prediction")




# Modeling log-transformed monetary output --------------------------------

# Examine Income2005 in the training set
summary(income_train$Income2005)

# Write the formula for log income as a function of the tests and print it
(fmla.log <- log(Income2005) ~ Arith + Word + Parag + Math + AFQT)

# Fit the linear model
model.log <-  lm(fmla.log,income_train)

# Make predictions on income_test
income_test$logpred <- predict(model.log,income_test)
summary(income_test$logpred)

# Convert the predictions to monetary units
income_test$pred.income <- exp(income_test$logpred)
summary(income_test$pred.income)

#  Plot predicted income (x axis) vs income
ggplot(income_test, aes(x = pred.income, y = Income2005)) + 
  geom_point() + 
  geom_abline(color = "blue")




# -------------------------------------------------------------------------

# Comparing RMSE and root-mean-squared Relative Error

# fmla.abs is in the workspace
fmla.abs

# model.abs is in the workspace
summary(model.abs)

# Add predictions to the test set
income_test <- income_test %>%
  mutate(pred.absmodel = predict(model.abs, income_test),      # predictions from model.abs
         pred.logmodel = exp(predict(model.log, income_test))) # predictions from model.log

# Gather the predictions and calculate residuals and relative error
income_long <- income_test %>% 
  gather(key = modeltype, value = pred, pred.absmodel, pred.logmodel) %>%
  mutate(residual = pred - Income2005,     # residuals
         relerr   = residual / Income2005) # relative error

# Calculate RMSE and relative RMSE and compare
income_long %>% 
  group_by(modeltype) %>%                       # group by modeltype
  summarize(rmse     = sqrt(mean(residual^2)),  # RMSE
            rmse.rel = sqrt(mean(relerr^2)))    # Root mean squared relative error




# 02.02.2022 --------------------------------------------------------------
#'
#' Input transforms: the "hockey stick"
#'

# houseprice is in the workspace
summary(houseprice)

# Create the formula for price as a function of squared size
(fmla_sqr <- as.formula(price ~ I(size^2)))

# Fit a model of price as a function of squared size (use fmla_sqr)
model_sqr <- lm(fmla_sqr,houseprice)

# Fit a model of price as a linear function of size
model_lin <- lm(price ~ size,houseprice)

# Make predictions and compare
houseprice %>% 
  mutate(pred_lin = predict(model_lin),       # predictions from linear model
         pred_sqr = predict(model_sqr)) %>%   # predictions from quadratic model 
  gather(key = modeltype, value = pred, pred_lin, pred_sqr) %>% # gather the predictions
  ggplot(aes(x = size)) + 
  geom_point(aes(y = price)) +                   # actual prices
  geom_line(aes(y = pred, color = modeltype)) + # the predictions
  scale_color_brewer(palette = "Dark2")



# -------------------------------------------------------------------------



# houseprice is in the workspace
summary(houseprice)

# fmla_sqr is in the workspace
fmla_sqr

# Create a splitting plan for 3-fold cross validation
set.seed(34245)  # set the seed for reproducibility
splitPlan <- kWayCrossValidation(nrow(houseprice), 3, NULL, NULL)

# Sample code: get cross-val predictions for price ~ size
houseprice$pred_lin <- 0  # initialize the prediction vector
for(i in 1:3) {
  split <- splitPlan[[i]]
  model_lin <- lm(price ~ size, data = houseprice[split$train,])
  houseprice$pred_lin[split$app] <- predict(model_lin, newdata = houseprice[split$app,])
}

# Get cross-val predictions for price as a function of size^2 (use fmla_sqr)
houseprice$pred_sqr <- 0 # initialize the prediction vector
for(i in 1:3) {
  split <- splitPlan[[i]]
  model_sqr <- lm(fmla_sqr, data = houseprice[split$train, ])
  houseprice$pred_sqr[split$app] <- predict(model_sqr, newdata = houseprice[split$app, ])
}

# Gather the predictions and calculate the residuals
houseprice_long <- houseprice %>%
  gather(key = modeltype, value = pred, pred_lin, pred_sqr) %>%
  mutate(residuals = pred - price)

# Compare the cross-validated RMSE for the two models
houseprice_long %>% 
  group_by(modeltype) %>% # group by modeltype
  summarize(rmse = sqrt(mean(residuals^2)))





# -------------------------------------------------------------------------

# Logistic regression to predict probabilities





