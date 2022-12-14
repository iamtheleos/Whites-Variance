#MICRO TESTE 3


#Variancia de White . 
#comparar com a matriz de cov ajustada para heterocedasticidade 

##Carregando pacotes necess?rios
library(car)
library(lmtest)
library(sandwich)

head(Salaries)

##CRIANDO OS OBJETOS: MATRIX X e -----

x0 <- rep(1, 397)
x1 <- matrix(data=Salaries$yrs.since.phd) #anos de estudo
x2 <- matrix(data=Salaries$yrs.service) #idade
x <- matrix(data=cbind(x0, x1, x2), nrow = 397, ncol = 3) #MATRIZ X
y <- matrix(data=Salaries$salary) #salario (Var dependente) MATRIX Y


##cRIANDO A MATRIZ M----

#A matriz M surge das equa??es normais do MQO ap?s algumas manipula??es alg?bricas.
###Sua f?rumula ? 

#############m = (I - x(x'x)^-1x').

##Portanto, precisamos criar uma identidade (com tra?o igual n? de linhas de X).

I <- diag(rep(1, 397))

m = I-(x%*%(solve(t(x)%*%x))%*%t(x))
m       

#RES?DUOS-----

##Novamente das equa??es normais, os res?duos s?o 

############e = my

#Logo, define-se:


e <- m%*%y
head(e)

#TRA?O DE In e Ik-----

##A vari?ncia amostral tem formula

############### s^2 = e'e/(n - k)

###em que n e k s?o os tra?os da matriz In e Ik = x(x'x)^-1x.

###Precisamos da vari?ncia amostra, pois a vari?ncia populacional ? desconhecida.

###Portanto, vamos definir esses tra?os com a fun??o sum do R:

n <- sum(diag(I))
k <- sum(diag(solve(t(x)%*%x)%*%(t(x)%*%x)))


#MATRIZ POSITIVA DEFINIDA -----

#A estrat?gia aqui foi elevar a matriz-coluna de res?duos ao quadrado e diagona-
#liz?-la para assim obter uma forma funcional da matriz positiva definida da
#variancia de White.

sqr_res <- e^2
mat_diag_res<-diag(as.numeric(sqr_res),397)
View(head(mat_diag_res))

#Vari?ncia de White----

#Sua f?rmula ?:

##########Var_white(B)= (n/(n-k))(X'X)-?*X'*{sqr_res}*X*(X'X)-?

Var_white<-((solve(t(x)%*%x))%*%t(x)%*%mat_diag_res%*%x%*%(solve(t(x)%*%x))*(n/(n-k)))
Var_white


#Testar a v?lidade da matriz encontrada----

##Com o comvando 'vcovHC' do pacotece lmtest verificamos a matriz de covari?ncia
##do estimador de MQO para beta corrigida para heterocedasticidade

vcovHC(lm(y~x1+x2),type="HC1")
