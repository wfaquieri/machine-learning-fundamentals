

# Building a simple decision tree -----------------------------------------

# Load the rpart package
library(rpart)

# Build a lending model predicting loan outcome versus loan amount and credit score
loan_model <- rpart(outcome ~ loan_amount + credit_score, data = loans, method = "class", control = rpart.control(cp = 0))

# Make a prediction for someone with good credit
predict(loan_model, good_credit, type = "class")

# Make a prediction for someone with bad credit
predict(loan_model, bad_credit, type = "class")


# Visualizing classification trees ----------------------------------------

# Examine the loan_model object
loan_model

# Load the rpart.plot package
library(rpart.plot)

# Plot the loan_model with default settings
rpart.plot(loan_model)

# Plot the loan_model with customized settings
rpart.plot(loan_model, type = 3, box.palette = c("red", "green"), fallen.leaves = TRUE)




# Criação de conjuntos de dados de teste aleatórios -----------------------


#'Antes de construir um modelo de empréstimo mais sofisticado, é importante reter uma parte dos 
#'dados do empréstimo para simular quão bem eles irão prever os resultados de futuros solicitantes 
#'de empréstimo. Você pode usar 75% das observações para treinamento e 25% para testar o modelo.

# Determine the number of rows for training
nrow(loans) # 11312

# Create a random sample of row IDs
sample_rows <- sample(nrow(loans), nrow(loans)*0.75) # 8484 linhas #data training

# Create the training dataset
loans_train <- loans[sample_rows,]

# Create the test dataset
loans_test <- loans[-sample_rows,]



# Construindo e avaliando uma árvore maior --------------------------------

#'
#' Anteriormente, você criava uma árvore de decisão simples que usava a pontuação de crédito do requerente e o valor do empréstimo solicitado para prever o resultado do empréstimo.
#' 
#' O Lending Club tem informações adicionais sobre os candidatos, como situação de propriedade de casa, tempo de emprego, finalidade do empréstimo e falências anteriores, que podem ser úteis para fazer previsões mais precisas.
#' 
#' Usando todos os dados disponíveis do candidato, construa um modelo de empréstimo mais sofisticado usando o conjunto de dados de treinamento aleatório criado anteriormente. Em seguida, use este modelo para fazer previsões no conjunto de dados de teste para estimar o desempenho do modelo em futuros pedidos de empréstimo.
#' 
#' O pacote rpart é carregado no espaço de trabalho e os conjuntos de dados loans_train e loans_test foram criados.
#'

# Grow a tree using all of the available applicant data
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(cp = 0))

# Make predictions on the test dataset
loans_test$pred <- predict(loan_model, loans_test, type = "class")

# Examine the confusion matrix
table(loans_test$pred, loans_test$outcome)

# Compute the accuracy on the test dataset
mean(loans_test$pred == loans_test$outcome)

 

# Prevenindo árvores crescidas --------------------------------------------


# A árvore cultivada no conjunto completo de dados de candidatos tornou-se extremamente grande e extremamente complexa, com centenas de divisões e nós de folha contendo apenas um punhado de candidatos. Essa árvore seria quase impossível para um agente de crédito interpretar.
# 
# Usando os métodos de pré-poda para parar antecipadamente, você pode evitar que uma árvore fique muito grande e complexa. Veja como as rpartopções de controle para a profundidade máxima da árvore e a contagem mínima da divisão afetam a árvore resultante.

# Grow a tree with maxdepth of 6
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(cp = 0, maxdepth = 6))

# Make a class prediction on the test set
loans_test$pred <- predict(loan_model, loans_test, type = "class")

# Compute the accuracy of the simpler tree
mean(loans_test$pred == loans_test$outcome)

# Swap maxdepth for a minimum split of 500 
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(cp = 0, minsplit = 500))

# Run this. How does the accuracy change?
loans_test$pred <- predict(loan_model, loans_test, type = "class")
mean(loans_test$pred == loans_test$outcome)





# Criando uma árvore bem podada -------------------------------------------


# Impedir o crescimento de uma árvore pode levá-la a ignorar alguns aspectos dos dados ou perder tendências importantes que pode ter descoberto mais tarde.
# 
# Usando a pós-poda , você pode intencionalmente fazer crescer uma árvore grande e complexa e depois podá-la para ficar menor e mais eficiente.
# 
# Neste exercício, você terá a oportunidade de construir uma visualização do desempenho da árvore versus complexidade e usar essas informações para podar a árvore a um nível apropriado.


# Grow an overly complex tree
loan_model <- rpart(outcome ~ ., data = loans_train, method = "class", control = rpart.control(cp = 0))

# Examine the complexity plot
plotcp(loan_model)

# Prune the tree
loan_model_pruned <- prune(loan_model, cp = 0.0014)

# Compute the accuracy of the pruned tree
loans_test$pred <- predict(loan_model_pruned, loans_test, type = "class")

mean(loans_test$pred == loans_test$outcome)



# Construindo um modelo de floresta aleatório -----------------------------


# Load the randomForest package
library(randomForest)

# Build a random forest model
loan_model <- randomForest(outcome ~ ., data = loans_train)

# Compute the accuracy of the random forest
loans_test$pred <- predict(loan_model, loans_test, type = "class")
mean(loans_test$pred == loans_test$outcome)

