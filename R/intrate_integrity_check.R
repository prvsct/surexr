library(tidyverse)

# --- INTRODUÇÃO ---
#
# Esse código constrói uma tabela para a taxa de juros que exibe qual série foi utilizada,
# o período amostral e o número de observações para cada país.
#
# Em seguida, monta a base final com as séries selecionadas para a taxa de juros para cada país.
#
# ATENÇÃO: antes de começar, verificar se as bases corretas foram salvas em intrate_download.R

# ---- CARRREGAMENTO DOS PAÍSES E DE TIMESPAN CONFORME definir_base.R ----

# Lista de países
load(file = "data//paises_iso.Rdata")

# ---- CARREGAMENTO DAS BASES SALVAS EM intrate_download.R ----

# Lista completa de paises
load(file = "data//paises_iso.Rdata")

# Treasury bills
load(file = "data//treasury_bills.Rdata")

# Deposit rate
load(file = "data//deposit_rate.Rdata")

# Gov Bonds
load(file = "data//gov_bonds.Rdata")

# --- PREPARAÇÃO DA TABELA ----

# Códigos do IFS de cada série
intrate_ifs_codes <- c(colnames(treasury_bills)[3],
                       colnames(deposit_rate)[3],
                       colnames(gov_bonds)[3])

# Criação do dataframe
intrate_tabela <- data.frame("País"=character(3*length(paises_iso)),
                             "Série"=character(3*length(paises_iso)),
                             "Amostra"=character(3*length(paises_iso)),
                             "Observações"=character(3*length(paises_iso)))

# Códigos dos países na coluna de país
intrate_tabela$País <- rep(paises_iso,3)[order(rep(paises_iso,3))]

# Códigos das séries nas colunas de série
intrate_tabela$Série <- rep(intrate_ifs_codes,23)

# ---- PREENCHIMENTO PARA TREASURY BILLS ----
#
# A ideia é realizar um for para cada uma das três séries. Tome como exemplo treasury_bills
# Neste for, intrate_tabela cuja série for de treasury_bills (conforme itrate_ifs_codes) irá
# ter sua coluna de Amostra preenchida pelo paste do começo de year_month até o final de
# year_month do país i. Em seguida, será feito o mesmo para calcular o número de observações,
# ambos fazendo proveito de length(). Analogamente para as  demais séries

for(i in paises_iso){

  # Preenchimento da coluna de Amostra
  intrate_tabela$Amostra[intrate_tabela$País==i & intrate_tabela$Série==intrate_ifs_codes[1]] <-
    paste(treasury_bills$year_month[treasury_bills$iso2c==i][1],
          treasury_bills$year_month[treasury_bills$iso2c==i][length(treasury_bills$year_month[treasury_bills$iso2c==i])],
          sep = " a ")

  # Preenchimento do número de observações
  intrate_tabela$Observações[intrate_tabela$País==i & intrate_tabela$Série==intrate_ifs_codes[1]] <-
    length(treasury_bills$year_month[treasury_bills$iso2c==i])

}

# ---- PREENCHIMENTO PARA DEPOSIT RATES ----

for(i in paises_iso){

  # Preenchimento da coluna de Amostra
  intrate_tabela$Amostra[intrate_tabela$País==i & intrate_tabela$Série==intrate_ifs_codes[2]] <-
    paste(deposit_rate$year_month[deposit_rate$iso2c==i][1],
          deposit_rate$year_month[deposit_rate$iso2c==i][length(deposit_rate$year_month[deposit_rate$iso2c==i])],
          sep = " a ")

  # Preenchimento do número de observações
  intrate_tabela$Observações[intrate_tabela$País==i & intrate_tabela$Série==intrate_ifs_codes[2]] <-
    length(deposit_rate$year_month[deposit_rate$iso2c==i])

}

# ---- PRENCHIMENTO PARA GOV BONDS ----

for(i in paises_iso){

  # Preenchimento da coluna de Amostra
  intrate_tabela$Amostra[intrate_tabela$País==i & intrate_tabela$Série==intrate_ifs_codes[3]] <-
    paste(gov_bonds$year_month[gov_bonds$iso2c==i][1],
          gov_bonds$year_month[gov_bonds$iso2c==i][length(gov_bonds$year_month[gov_bonds$iso2c==i])],
          sep = " a ")

  # Preenchimento do número de observações
  intrate_tabela$Observações[intrate_tabela$País==i & intrate_tabela$Série==intrate_ifs_codes[3]] <-
    length(gov_bonds$year_month[gov_bonds$iso2c==i])

}

# --- PREPARAÇÃO PARA EXPORTAR ----

intrate_tabela_export <- intrate_tabela

# Substitui "NA a" por "Ausente"
intrate_tabela_export$Amostra <- str_replace(string = intrate_tabela_export$Amostra,
                                      pattern = "NA a ",
                                      replacement = "Ausente")
# Corrige GB
# Em deposit_rate, havia uma linha para GB com apenas valores ausentes, de forma que consta para
# GB deposit_rate uma amostra NA com 1 observação
intrate_tabela_export$Amostra[23] <- "Ausente"
intrate_tabela_export$Observações[23] <- 0

# Substitui código iso2c do país pelo nome do país
nomes <- surexr::ifs_countries[which(surexr::ifs_countries$Code %in% paises_iso),]
intrate_tabela_export$País <- rep(nomes$Name,3)[order(rep(nomes$Name,3))]

# Adiciona coluna de descrição da série
intrate_tabela_export$Descrição <- NA
intrate_tabela_export$Descrição[intrate_tabela_export$Série==intrate_ifs_codes[1]] <- "Treasury Bills"
intrate_tabela_export$Descrição[intrate_tabela_export$Série==intrate_ifs_codes[2]] <- "Deposit Rates"
intrate_tabela_export$Descrição[intrate_tabela_export$Série==intrate_ifs_codes[3]] <- "Government Bonds"

# Reordena as colunas
intrate_tabela_export <- intrate_tabela_export[,c(1,2,5,3,4)]

# Exportação
print(xtable::xtable(x = intrate_tabela_export),
      floating = F,
      latex.environments = NULL,
      booktabs = T,
      include.rownames = F,
      file = "C:\\Pedro Roveri Scatimburgo\\Outputs\\intrate_tabela.tex")
