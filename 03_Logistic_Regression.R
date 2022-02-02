
# Construindo modelos de regressão logística simples ----------------------

#' O donors conjunto de dados contém 93.462 exemplos de pessoas enviadas em uma solicitação de arrecadação de fundos para veteranos militares paralisados. A donatedcoluna indica 1se a pessoa fez uma doação em resposta à correspondência e de 0outra forma. Esse resultado binário será a variável dependente do modelo de regressão logística.
#'
#' As colunas restantes são características dos doadores em potencial que podem influenciar seu comportamento de doação. Estas são as variáveis ​​independentes do modelo .
#'
#' Ao construir um modelo de regressão, geralmente é útil formar uma hipótese sobre quais variáveis ​​independentes serão preditivas da variável dependente. A bad_addresscoluna, que é definida como 1um endereço de correspondência inválido e 0outros, parece que pode reduzir as chances de uma doação. Da mesma forma, pode-se suspeitar que o interesse religioso ( interest_religion) e o interesse pelos assuntos dos veteranos ( interest_veterans) estariam associados a maiores doações de caridade.
#'
#' Neste exercício, você usará esses três fatores para criar um modelo simples de comportamento de doação. O conjunto de dados donorsestá disponível em seu espaço de trabalho.

str(donors)

# Explore the dependent variable
table(donors$donated)

# Build the donation model
donation_model <- glm(donated ~ bad_address + interest_religion + interest_veterans, 
                      data = donors, family = "binomial")

# Summarize the model results
summary(donation_model)

# Call:
#   glm(formula = donated ~ bad_address + interest_religion + interest_veterans,
#       family = "binomial", data = donors)
# 
# Deviance Residuals:
#   Min       1Q   Median       3Q      Max
# -0.3480  -0.3192  -0.3192  -0.3192   2.5678
# 
# Coefficients:
#   Estimate Std. Error  z value Pr(>|z|)
# (Intercept)       -2.95139    0.01652 -178.664   <2e-16 ***
#   bad_address       -0.30780    0.14348   -2.145   0.0319 *
#   interest_religion  0.06724    0.05069    1.327   0.1847
# interest_veterans  0.11009    0.04676    2.354   0.0186 *
#   ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 37330  on 93461  degrees of freedom
# Residual deviance: 37316  on 93458  degrees of freedom
# AIC: 37324
# 
# Number of Fisher Scoring iterations: 5


# Making a binary prediction ----------------------------------------------

# Por padrão, predict() produz previsões em termos de probabilidade de log, a menos que type = "response"
# seja especificado. Isso converte as probabilidades de log em probabilidades .

# Como um modelo de regressão logística estima a probabilidade do resultado, cabe a você determinar o limite no qual a probabilidade implica ação. É preciso equilibrar os extremos de ser muito cauteloso e muito agressivo. Por exemplo, se você solicitar apenas as pessoas com probabilidade de doação de 99% ou mais, poderá perder muitas pessoas com probabilidades estimadas mais baixas que ainda optam por doar. É particularmente importante considerar esse equilíbrio para resultados gravemente desequilibrados, como neste conjunto de dados, onde as doações são relativamente raras.

# Estimate the donation probability
donors$donation_prob <- predict(donation_model, type = "response")
table(donors$donated)

# Find the donation probability of the average prospect
mean(donors$donated)
88751/(88751+4711)

# Predict a donation if probability of donation is greater than average
donors$donation_pred <- ifelse(donors$donation_prob > 0.0504, 1, 0)

# Calculate the model's accuracy
mean(donors$donated == donors$donation_pred)




# Calculating ROC Curves and AUC ------------------------------------------

#' Os exercícios anteriores demonstraram que a precisão é uma medida muito enganosa do desempenho do modelo em conjuntos de dados desequilibrados. 
#' 
#' O gráfico do desempenho do modelo ilustra melhor a compensação entre um modelo que é excessivamente agressivo e outro que é excessivamente passivo.
#' 
#' Neste exercício, você criará uma curva ROC e calculará a área sob a curva (AUC) para avaliar o modelo de regressão logística de doações que você construiu anteriormente.
#' 

# Load the pROC package
library(pROC)

# Create a ROC curve
ROC <- roc(donors$donated,donors$donation_prob)

# Plot the ROC curve
plot(ROC, col = "blue")

# Calculate the area under the curve (AUC)
auc(ROC) ## Gerou uma AUC muito retilínea (indicativa de um modelo muito ruim).



# Coding categorical features ---------------------------------------------

# Às vezes, um conjunto de dados contém valores numéricos que representam um recurso categórico.
# 
# No conjunto de dados donors, wealth_rating utiliza números para indicar o nível de riqueza do doador:
#   
# 0 = desconhecido
# 1 = baixo
# 2 = Médio
# 3 = alto
# 
# Este exercício ilustra como preparar esse tipo de recurso categórico e examina seu impacto em um modelo de regressão logística. 
# O dataframe donors é carregado em seu espaço de trabalho.
# 

# Convert the wealth rating to a factor
donors$wealth_levels <- factor(donors$wealth_rating, levels = c(0,1,2,3), labels = c("Unknown","Low","Medium","High"))

str(donors)
summary(donors$wealth_levels)

# Use relevel() to change reference category
donors$wealth_levels <- relevel(donors$wealth_levels, ref = "Medium")

res_model <- glm(donated ~ wealth_levels, data = donors, family = "binomial")

# See how our factor coding impacts the model
summary(res_model)

# Call:
#   glm(formula = donated ~ wealth_levels, family = "binomial", data = donors)
# 
# Deviance Residuals: 
#   Min       1Q   Median       3Q      Max  
# -0.3320  -0.3243  -0.3175  -0.3175   2.4582  
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)          -2.91894    0.03614 -80.772   <2e-16 ***
# wealth_levelsUnknown -0.04373    0.04243  -1.031    0.303    
# wealth_levelsLow     -0.05245    0.05332  -0.984    0.325    
# wealth_levelsHigh     0.04804    0.04768   1.008    0.314    
# ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 37330  on 93461  degrees of freedom
# Residual deviance: 37323  on 93458  degrees of freedom
# AIC: 37331
# 
# Number of Fisher Scoring iterations: 5



# Handling missing data ---------------------------------------------------
# Find the average age among non-missing values
summary(donors$age)

# Impute missing age values with the mean age
donors$imputed_age <- ifelse(is.na(donors$age),round(mean(donors$age,na.rm = T),2),donors$age)

# Create missing value indicator for age
donors$missing_age <- ifelse(is.na(donors$age),1,0)



# Building a more sophisticated model -------------------------------------


#' Os doadores que não doaram recentemente e com frequência podem estar especialmente propensos a doar novamente; 
#' em outras palavras, o impacto combinado de tempo e frequência pode ser maior do que a soma dos efeitos separados.
#' 
#' Como esses preditores juntos têm um impacto maior na variável dependente, seu efeito conjunto deve ser modelado como uma interação. O 


# Build a recency, frequency, and money (RFM) model
rfm_model <- glm(donated ~ money + recency * frequency, data = donors, family = "binomial")

# Summarize the RFM model to see how the parameters were coded
summary(rfm_model)

# Call:
#   glm(formula = donated ~ money + recency * frequency, family = "binomial", 
#       data = donors)
# 
# Deviance Residuals: 
#   Min       1Q   Median       3Q      Max  
# -0.3696  -0.3696  -0.2895  -0.2895   2.7924  
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)                       -2.9999     0.3086  -9.721   <2e-16 ***
#   moneyHIGH                         -0.3619     0.0430  -8.415   <2e-16 ***
#   recencyCURRENT                    -0.1511     0.3094  -0.488    0.625    
# frequencyFREQUENT                 -0.5164     0.5162  -1.000    0.317    
# recencyCURRENT:frequencyFREQUENT   1.0179     0.5171   1.968    0.049 *  
#   ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 37330  on 93461  degrees of freedom
# Residual deviance: 36938  on 93457  degrees of freedom
# AIC: 36948
# 
# Number of Fisher Scoring iterations: 6

# Compute predicted probabilities for the RFM model
rfm_prob <- predict(rfm_model, type = "response")

# Plot the ROC curve and find AUC for the new model
library(pROC)
ROC <- roc(donors$donated,rfm_prob)
plot(ROC, col = "red")
auc(ROC) # Area under the curve: 0.5785


# Building a stepwise regression model ------------------------------------

## Exclusao reversa / selecao direta (forward)

# Specify a null model with no predictors
null_model <- glm(donated ~ 1, data = donors, family = "binomial")

# Specify the full model using all of the potential predictors
full_model <- glm(donated ~ ., data = donors, family = "binomial")

# Use a forward stepwise algorithm to build a parsimonious model
step_model <- step(null_model, scope = list(lower = null_model, upper = full_model), 
                   direction = "forward")

# Estimate the stepwise donation probability
step_prob <- predict(step_model, type = "response")

# Plot the ROC of the stepwise model
library(pROC)
ROC <- roc(donors$donated, step_prob)
plot(ROC, col = "red")
auc(ROC)
