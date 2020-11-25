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


# --- SALVAMENTO DAS BASES ----

# gdp_sa
save(gdp_sa, file = "data//gdp_sa.Rdata")

# gdp_nsa
save(gdp_nsa, file = "data//gdp_nsa.Rdata")
