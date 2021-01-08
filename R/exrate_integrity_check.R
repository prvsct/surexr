library(tidyverse)

# --- INTRODUÇÃO ----
#
# Esse código elabora a tabela de taxa de câmbio nominal com o período amostral,
# número de observações e código da série para cada país, para ser inserida na
# seção de dados do capítulo de metodologia, como exrate_table.
#
# ATENÇÃO: antes de prosseguir, verificar se exrate foi corretamente carrega

# ---- CARREGAMENTO DA BASE E DE PAISES ----

load("data//exrate.Rdata")

load("data//paises_iso.Rdata")

# Pivotamento para checar integridade
exrate_wide <- pivot_wider(exrate, names_from = "iso2c", values_from = colnames(exrate)[3])

# ---- PREPARAÇÃO DA TABELA ----

# Código do IFS da série
exrate_ifs_code <- colnames(exrate)[3]

# Criação do dataframe
exrate_table <- data.frame("País"=character(length(paises_iso)),
                           "Série"=character(length(paises_iso)),
                           "Descrição"=character(length(paises_iso)),
                           "Amostra"=character(length(paises_iso)),
                           "Observações"=character(length(paises_iso)))

# Código de países na coluna País
exrate_table$País <- paises_iso

# Código da série na coluna Série
exrate_table$Série <- exrate_ifs_code

# Descrição da série na coluna Descrição
exrate_table$Descrição <- "Exchange Rates"

# --- PREENCHIMENTO ----

# Procedimento análogo ao executado em intrate_integrity_check.R

for(i in paises_iso){

  # Preenchimento da coluna de Amostra
  exrate_table$Amostra[exrate_table$País==i] <-
    paste(exrate$year_month[exrate$iso2c==i][1],
          exrate$year_month[exrate$iso2c==i][length(exrate$year_month[exrate$iso2c==i])],
          sep = " a ")

  # Preenchimento da coluna de Observações
  exrate_table$Observações[exrate_table$País==i] <-
    length(exrate$year_month[exrate$iso2c==i])

}

# ---- PREPARAÇÃO PARA EXPORTAR ----

exrate_table_export <- exrate_table

# Subtitui o código do país pelo nome
nomes <- surexr::ifs_countries[which(surexr::ifs_countries$Code %in% paises_iso),]
exrate_table_export$País <- nomes$Name

# Exportação
print(xtable::xtable(x = exrate_table_export),
      floating = F,
      latex.environments = NULL,
      booktabs = T,
      include.rownames = F,
      file = "C:\\Pedro Roveri Scatimburgo\\Outputs\\exrate_tabela.tex")
