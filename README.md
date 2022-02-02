# machine-learning-fundamentals

Repositório com algumas anotações, reflexões, scripts dos estudos sobre Machine Learning para consulta posterior.

## Por que transformar variáveis de entrada

Há muitas razões pelas quais você pode querer transformar as variáveis de entrada antes da modelagem. A razão mais importante é que você tem conhecimento de domínio que lhe diz que uma variável transformada pode ser mais informativa. Por exemplo, a inteligência animal está relacionada à razão entre a massa cerebral e a massa corporal em dois terços, e não diretamente à massa cerebral ou corporal. 

Você também pode querer transformar variáveis por motivos pragmáticos, para tornar a variável mais fácil de modelar. A transformação de log para valores monetários é um exemplo disso. Os valores monetários possuem distribuição log-normal, ao aplicarmos log os dados resultantes serão distribuídos normalmente. Um modelo que prevê um resultado logarítmico, geralmente, terá um RMS-erro relativo menor e um RMSE maior. Lembrando que: 

-Erro relativo = (pred/y - 1)   

-RMSE = sqrt(mean(residuals^2))

Ou você pode querer transformar variáveis para atender a suposições de modelagem, como linearidade.

## Compare diferentes modelos 
Existem muitas transformações diferentes da variável que podem nos dar a forma que observamos nos dados. Se tivermos um conhecimento de domínio para preferir um, é assim que devemos escolher. Mas se não sabemos e estamos principalmente preocupados com a previsão precisa, devemos escolher aquela que parece nos dar o menor erro de previsão.

Devemos também validar o desempenho fora da amostra dos modelos, neste caso por validação cruzada. 


## Desafios

Construir um modelo para prever preço a partir de uma medida do tamanho da casa (área de superfície). 

Utilizar o conjunto de dados houseprice. As variáveis são:

-price: preço da casa em unidades de $ 1.000   

-size: área de superfície

Escreva uma fórmula, para expressar o preço em função do quadrado do tamanho. 

Ajuste um modelo e para comparação, ajuste um modelo linear usando a fórmula price ~ size.

Procure fazer previsões a partir dos dados de treinamento dos dois modelos e reúna as previsões em uma única coluna 'pred'.

Compare graficamente as previsões dos dois modelos com os dados. Qual se encaixa melhor?
