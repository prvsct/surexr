library(tidyverse)


# ----- INTRODUÇÃO ------

# Esse código realiza o download do volume de PIB trimestral, em USD, ano base 2010, sazonalmente ajustado
# Os países são aqueles definidos em paises_iso.R
# O período temporal são aqueles definidos em timespan

# Em seguida, calcula o crescimento do PIB trimestral e estatísticas descritivas

# ATENÇÃO: ANTES DE COMEÇAR, SEMPRE VERIFICAR OS PAÍSES COM load() CONFORME PRIMEIRA LINHA


# ---- CARREGAMENTO DOS PAISES ----

# Carrega a imagem de países conforme gerada por definir_base.R
# ATENÇÃO: se houver mudanças nos países, verificar se nova versão de países_iso.Rdata foi salva
load(file = "data/paises_iso.Rdata")

# ---- CARREGAMENTO DO PERÍODO AMOsTRAL ----

# Carrega a imagem do período amostral conforme gerada por definir_base.R
# ATENÇÃO: se houver mudanças no período amostral, verificar se nova versão de timespan.Rdata foi salva
load(file = "data/timespan.Rdata")

# ---- DEFINIÇÃO DOS CÓDIGOS

cod_gdp_sa <- "NGDP_R_K_SA_IX"
cod_gdp_nsa <- "NGDP_R_K_IX"


# ----- DOWNLOAD DOS DADOS SAZONALMENTE AJUSTADOS ------

# Usa surexr::ifs_data para baixar o volume de PIB trimestral, em USD, 2010=100, sazonalmente ajustado
# Os países são aqueles definidos em países_iso
# O período amostral é aquele definido em timespan
# É preciso assegurar que start e end sejam valores numéricos, daí o uso de as.numeric
# Analogamente para freq, que deve ser character
# NGDP_R_K_SA_IX conforme surexr::ifs_indicators
gdp_sa <- surexr::ifs_data(indicator = cod_gdp_sa,
                           country = paises_iso,
                           start = as.numeric(timespan["início"]),
                           end = as.numeric(timespan["final"]),
                           freq = "Q")

# # ---- CORTE DO PERÍODO FINAL DE 2014 ----
#
# # Na dissertação, o período usado é de 1999T1 a 2014T2.
# # Como só é possível selecionar anos cheios, é preciso remover os valores a partir de 2014T2
# # Ou seja, retirar observações de 2014-07 a 2014-12
# # ATENÇÃO: essa seção deve ser totalmente removida quando for rodar para o timespan mais recente
#
# corte_2014t2 <- c("2014-Q3","2014-Q4")
# gdp_sa <- dplyr::filter(.data = gdp_sa, !gdp_sa$year_quarter %in% corte_2014t2)

# ---- DOWNLOAD DOS DADOS NÃO SAZONALMENTE AJUSTADOS

# Segundo a dissertação, há países que não possuem dados sazonalmente ajustados na base. Quais?
gdp_sa_faltantes <- paises_iso[which(!paises_iso %in% gdp_sa$iso2c)]

# Mesmo processo anterior, mas para países em gdp_sa_faltantes
# Código: NGDP_R_K_IX
gdp_nsa <- surexr::ifs_data(indicator = cod_gdp_nsa,
                           country = gdp_sa_faltantes,
                           start = as.numeric(timespan["início"]),
                           end = as.numeric(timespan["final"]),
                           freq = "Q")

# ---- AJUSTE SAZONAL ----



