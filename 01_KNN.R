
# Load the 'class' package
library(class)


# Parte 1 ---------------------------------------------------------------

head(signs)
# Create a vector of labels
sign_types <- signs$sign_type

# Lembrar que cl são os rótulos dos dados de treino
# Classify the next sign observed
knn(train = signs[-1], test = next_sign, cl = sign_types)

# Examine the structure of the signs dataset
str(signs)

# Count the number of signs of each type
table(signs$sign_type)

# comando fornecido para ver se o nível médio de vermelho pode variar por tipo de sinal.
# Check r10's average red level by sign type
aggregate(r10 ~ sign_type, data = signs, mean)


# Parte 2 ---------------------------------------------------------------

# Use kNN to identify the test road signs
sign_types <- signs$sign_type
signs_pred <- knn(train = signs[-1], test = test_signs[-1], cl = sign_types)

# Create a confusion matrix of the predicted versus actual values
signs_actual <- test_signs$sign_type
# Use table()para explorar o desempenho do classificador na identificação dos três tipos de sinais (a matriz de confusão).
table(signs_pred, signs_actual)

# O objeto signs_actual contém os verdadeiros valores dos sinais.
# Compute the accuracy
mean(signs_pred == signs_actual)


# Parte 3 ---------------------------------------------------------------

# Por padrão, a knn()função no classpacote usa apenas o único vizinho mais próximo.

# Compare os k valores 1, 7 e 15 para examinar o impacto na precisão da classificação dos sinais de trânsito.

# Calcule a precisão do k = 1 modelo padrão usando o código fornecido e, em seguida, encontre a precisão do modelo usando mean()para comparar signs_actuale as previsões do modelo.
# Modifique a knn()chamada de função definindo k = 7 e encontre novamente o valor de precisão.
# Revise o código mais uma vez definindo k = 15 e encontre o valor de precisão mais uma vez.

# Compute the accuracy of the baseline model (default k = 1)
k_1 <- knn(train = signs[-1], test = signs_test[-1], cl = sign_types)
mean(k_1 == signs_actual)

# Modify the above to set k = 7
k_7 <- knn(train = signs[-1], test = signs_test[-1], cl = sign_types, k = 7)
mean(k_7 == signs_actual)

# k igual a raiz do n. obs da base de treino
n_trains <- round(sqrt(nrow(signs)),0)

k_12 <- knn(train = signs[-1], test = signs_test[-1], cl = sign_types, k = n_trains)

mean(k_12 == signs_actual)

# Set k = 15 and compare to the above
k_15 <- knn(train = signs[-1], test = signs_test[-1], cl = sign_types, k = 15)
mean(k_15 == signs_actual)



# Vendo como os vizinhos votaram ------------------------------------------

# Parâmetro 'prob' 
# If this is true, the proportion of the votes for the winning class are returned as attribute prob.

# Quando vários vizinhos mais próximos votam, às vezes pode ser útil examinar se os eleitores foram unânimes ou amplamente separados.
# 
# Por exemplo, saber mais sobre a confiança dos eleitores na classificação pode permitir que um veículo autônomo seja cauteloso no caso de haver alguma chance de que um sinal de pare esteja à frente.
# 
# Neste exercício, você aprenderá como obter os resultados da votação da knn()função.

# Construa um modelo kNN com o prob = TRUE parâmetro para calcular as proporções de votos. Definir k = 7.
# Use a attr() função para obter as proporções de votos para a classe prevista. Eles são armazenados no atributo "prob".
# Examine os primeiros resultados da votação e percentagens usando a head() função para ver como a confiança varia de sinal para sinal.

# Use the prob parameter to get the proportion of votes for the winning class
sign_pred <- knn(train = signs[-1], test = signs_test[-1], cl = sign_types, k = 7, prob = T)

# Get the "prob" attribute from the predicted classes
sign_prob <- attr(sign_pred, "prob")

# Examine the first several predictions
head(sign_pred)

# Examine the proportion of votes for the winning class
head(sign_prob)


# testando ----------------------------------------------------------------

library(MASS) # Conjunto de dados disponíveis no R

# Os dados do data() lista todos os conjuntos de dados nos pacotes carregados.
data()

library(purrr)
library(tibble)

dataset <- Traffic %>% as_tibble()

# Eliminando a 1ª coluna
sem_coluna_1 <- Traffic[-1] %>% as_tibble()

# end ---------------------------------------------------------------------


