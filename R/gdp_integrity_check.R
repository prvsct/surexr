library(tidyverse)

# --- INTRODUÇÃO ---
#
# Esse código gera a tabela GDP com período amostral, número de observações e série
# para cada país.
# ATENÇÃO: verificar se as bases foram corretamente carregadas

# --- CARREGAMENTO DAS BASES ----

# Lista de paises
load("data//paises_iso.Rdata")

# Crescimento do PIB
load("data//gdp_growth.Rdata")

# --- PREPARAÇÃO DA TABELA ----

# Código do IFS da série
gdp_ifs_code <- colnames(gdp_growth)[3]

# Criação do dataframe
gdp_growth_table <- data.frame("País"=character(length(paises_iso)),
                               "Série"=character(length(paises_iso)),
                               "Descrição"=character(length(paises_iso)),
                               "Amostra"=character(length(paises_iso)),
                               "Observações"=character(length(paises_iso)))

# Código de países na coluna País
gdp_growth_table$País <- paises_iso

# Código da série na coluna Série
gdp_growth_table$Série <- gdp_ifs_code

# Descrição da série na coluna Descrição
gdp_growth_table$Descrição <- "Seasonally Adjusted IFS GDP Index (2010=100)"

# --- PREENCHIMENTO ----

# Procedimento análogo ao executado em intrate_integrity_check.R

for(i in paises_iso){

  # Preenchimento da coluna de Amostra
  gdp_growth_table$Amostra[gdp_growth_table$País==i] <-
    paste(gdp_growth$year_quarter[gdp_growth$iso2c==i][1],
          gdp_growth$year_quarter[gdp_growth$iso2c==i][length(gdp_growth$year_quarter[gdp_growth$iso2c==i])],
          sep = " a ")

  # Preenchimento da coluna de Observações
  gdp_growth_table$Observações[gdp_growth_table$País==i] <-
    length(gdp_growth$year_quarter[gdp_growth$iso2c==i])

}

# Troca o código e descrição de PE e TE
gdp_growth_table$Série[gdp_growth_table$País=="PE" | gdp_growth_table$País=="TR"] <- "NGDP_R_K_IX"
gdp_growth_table$Descrição[gdp_growth_table$País=="PE" | gdp_growth_table$País=="TR"] <- "IFS GDP Index (2010=100)"


# ---- PREPARAÇÃO PARA EXPORTAR ----

gdp_growth_table_export <- gdp_growth_table

# Subtitui o código do país pelo nome
nomes <- surexr::ifs_countries[which(surexr::ifs_countries$Code %in% paises_iso),]
gdp_growth_table_export$País <- nomes$Name

# Exportação
print(xtable::xtable(x = gdp_growth_table_export),
      floating = F,
      latex.environments = NULL,
      booktabs = T,
      include.rownames = F,
      file = "C:\\Pedro Roveri Scatimburgo\\Outputs\\gdp_tabela.tex")
