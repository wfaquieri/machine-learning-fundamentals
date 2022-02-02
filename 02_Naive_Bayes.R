
# Probabilidades de computação --------------------------------------------

#'
#'O where9am é um df que contém 91 dias (treze semanas) de dados nos quais Brett 
#'registrou o seu location às 9h da manhã todos os dias, bem como se daytype foi um 
#'fim de semana ou dia de semana.
#'
#'Usando a fórmula de probabilidade condicional, você pode calcular a probabilidade 
#'de Brett estar trabalhando no escritório, visto que é um dia de semana.
#'
#'Cálculos como esses são a base do modelo de previsão de destino Naive Bayes que 
#'você desenvolverá em exercícios posteriores.
#'
#'

library(naivebayes)

# Compute P(A) 
p_A <- nrow(subset(where9am,location=="office"))/nrow(where9am)

# Compute P(B)
p_B <- nrow(subset(where9am,daytype=="weekday"))/nrow(where9am)

# Compute the observed P(A and B)
p_AB <- nrow(subset(where9am, location=="office" & daytype=="weekday"))/nrow(where9am)

# Compute P(A | B) and print its value
p_A_given_B <- p_AB/p_B
p_A_given_B




# Um modelo de localização simples Naive Bayes ----------------------------

#'
#'Os exercícios anteriores mostraram que a probabilidade de Brett estar no trabalho 
#'ou em casa às 9h depende muito de ser fim de semana ou dia de semana.
#'
#'Para ver essa descoberta em ação, use o where9am quadro de dados para construir um 
#'modelo Naive Bayes nos mesmos dados.
#'
#'Você pode então usar este modelo para prever o futuro: onde o modelo acha que 
#'Brett estará às 9h na quinta-feira e às 9h no sábado?
#'
#'O dataframe where9am está disponível em sua área de trabalho. Este conjunto de 
#'dados contém informações sobre a localização de Brett às 9h em dias diferentes.
#'
#'

# Load the naivebayes package
library(naivebayes)

# Build the location prediction model
locmodel <- naive_bayes(location ~ daytype, data = where9am)

# Nota - thursday9am é um objeto ou variável que representa um weekday
# Predict Thursday's 9am location
predict(locmodel, thursday9am)

# Nota - saturday9am é um objeto ou variável que denota um weekend
# Predict Saturdays's 9am location
predict(locmodel, saturday9am)





# Examinando probabilidades "brutas" --------------------------------------

# O naivebayespacote oferece várias maneiras de espiar dentro de um modelo 
# Naive Bayes.
# 
# Digitar o nome do objeto de modelo fornece as probabilidades a priori (gerais) e 
# condicionais de cada um dos preditores do modelo. Se alguém quisesse, você poderia usá-los para calcular as probabilidades posteriores (previstas) manualmente.
# 
# Alternativamente, R calculará as probabilidades posteriores para você se o 
# type = "prob" parâmetro for fornecido para a predict()função.
# 
# Usando esses métodos, examine como a probabilidade de localização prevista do 
# modelo para as 9h varia de um dia para o outro. O modelo locmodelque você ajustou 
# no exercício anterior está em sua área de trabalho.


# The 'naivebayes' package is loaded into the workspace
# and the Naive Bayes 'locmodel' has been built
locmodel

# ===================== Naive Bayes ===================== 
#   Call: 
#   naive_bayes.formula(formula = location ~ daytype, data = where9am)
# 
# A priori probabilities: 
#   
#   appointment      campus        home      office 
# 0.01098901  0.10989011  0.45054945  0.42857143 
# 
# Tables: 
#   
#   daytype   appointment    campus      home    office
# weekday   1.0000000 1.0000000 0.3658537 1.0000000
# weekend   0.0000000 0.0000000 0.6341463 0.0000000


# Obtain the predicted probabilities for Thursday at 9am
predict(locmodel, thursday9am , type = "prob")

# # Obtain the predicted probabilities for Thursday at 9am
# predict(locmodel, thursday9am , type = "prob")
# appointment    campus      home office
# [1,]  0.01538462 0.1538462 0.2307692    0.6

# Obtain the predicted probabilities for Saturday at 9am
predict(locmodel, saturday9am, type = "prob")

# # Obtain the predicted probabilities for Thursday at 9am
# predict(locmodel, thursday9am , type = "prob")
# appointment    campus      home office
# [1,]  0.01538462 0.1538462 0.2307692    0.6




# Um modelo de localização mais sofisticado -------------------------------

# O locations é um conjunto de dados que registra a localização de Brett a cada hora durante 
# 13 semanas. A cada hora, as informações de rastreamento incluem daytype(fim de semana ou 
# dia da semana), bem como hourtype(manhã, tarde, noite ou noite).
# 
# Usando esses dados, construa um modelo mais sofisticado para ver como a localização prevista 
# de Brett varia não apenas de acordo com o dia da semana, mas também com a hora do dia. 
# O conjunto de dados locationsjá está carregado em seu espaço de trabalho.
# 
# Você pode especificar variáveis independentes adicionais em sua fórmula usando o sinal de +  
# (por exemplo y ~ x + b).

# head(locations)
# 
#      daytype    hourtype     location
# 1    weekday     night        home
# 2    weekday     night        home
# 3    weekday     night        home
# 4    weekday     night        home
# 5    weekday     night        home
# 6    weekday     night        home
# 7    weekday   morning        home
# 8    weekday   morning        home
# 9    weekday   morning        home
# 10   weekday   morning      office

# Use a interface da fórmula R para construir um modelo onde a localização depende de daytype e 
# hourtype. Lembre-se de que a função naive_bayes()leva 2 argumentos: formula e data.
# 
# (location ~ daytype + hourtype)

# The 'naivebayes' package is loaded into the workspace already

# Build a NB model of location
locmodel <- naive_bayes(location ~ daytype + hourtype, data = locations)


# weekday_afternoon é um df de uma linha que guarda a info abaixo:
# 
# daytype  hourtype location
# weekday afternoon  office

# Predict Brett's location on a weekday afternoon
predict(locmodel,weekday_afternoon)

# Predict Brett's location on a weekday evening
predict(locmodel,weekday_evening)



# Preparando-se para circunstâncias imprevistas ---------------------------

# Enquanto Brett rastreava sua localização por 13 semanas, ele nunca foi ao escritório durante o fim de semana. Consequentemente, a probabilidade conjunta de P (escritório e fim de semana) = 0.
# 
# Explore como isso afeta a probabilidade prevista de que Brett vá trabalhar no fim de semana no futuro. Além disso, você pode ver como o uso da correção de Laplace permitirá uma pequena chance para esses tipos de circunstâncias imprevistas.
# 
# O modelo locmodeljá está em sua área de trabalho, junto com o dataframe weekend_afternoon.

## Conceito importante * correção de Laplace ou Laplace smoothing *

# Use locmodel para gerar as probabilidades previstas para uma tarde de fim de semana usando a predict()função. Lembre-se de definir o typeargumento.

# The 'naivebayes' package is loaded into the workspace already
# The Naive Bayes location model (locmodel) has already been built

# Observe the predicted probabilities for a weekend afternoon
predict(locmodel, weekend_afternoon, type = "prob")

# [1] home
# Levels: appointment campus home office restaurant store theater
# > predict(locmodel, weekend_afternoon, type = "prob")
# appointment campus      home office restaurant      store theater
# [1,]  0.02472535      0 0.8472217      0  0.1115693 0.01648357       0


# Build a new model using the Laplace correction
locmodel2 <- naive_bayes(location ~ daytype + hourtype, data = locations, lapalace = 1)

# Observe the new predicted probabilities for a weekend afternoon
predict(locmodel2, weekend_afternoon, type = "prob")

# appointment      campus      home      office restaurant      store
# [1,]  0.01107985 0.005752078 0.8527053 0.008023444  0.1032598 0.01608175
# theater
# [1,] 0.003097769










































