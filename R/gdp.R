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
load(file = "data//paises_iso.Rdata")

# ---- CARREGAMENTO DO PERÍODO AMOsTRAL ----

# Carrega a imagem do período amostral conforme gerada por definir_base.R
# ATENÇÃO: se houver mudanças no período amostral, verificar se nova versão de timespan.Rdata foi salva
load(file = "data//timespan.Rdata")


# ----- DOWNLOAD DOS DADOS SAZONALMENTE AJUSTADOS ------

# Usa surexr::ifs_data para baixar o volume de PIB trimestral, em USD, 2010=100, sazonalmente ajustado
# Os países são aqueles definidos em países_iso
# O período amostral é aquele definido em timespan
# É preciso assegurar que start e end sejam valores numéricos, daí o uso de as.numeric
# Analogamente para freq, que deve ser character
# NGDP_R_K_SA_IX conforme surexr::ifs_indicators
gdp_sa <- surexr::ifs_data(indicator = "NGDP_R_K_SA_IX",
                           country = paises_iso,
                           start = as.numeric(timespan["início"]),
                           end = as.numeric(timespan["final"]),
                           freq = "Q")

# ---- CORTE DO PERÍODO FINAL DE 2014 ----

# Na dissertação, o período usado é de 1999T1 a 2014T2.
# Como só é possível selecionar anos cheios, é preciso remover os valores a partir de 2014T2
# Ou seja, retirar observações de 2014-07 a 2014-12
# ATENÇÃO: essa seção deve ser totalmente removida quando for rodar para o timespan mais recente

corte_2014t2 <- c("2014-Q3","2014-Q4")
gdp_sa <- dplyr::filter(.data = gdp_sa, !gdp_sa$year_quarter %in% corte_2014t2)

# ---- PIVOTAMENTO

gdp_sa_wide <- pivot_wider(gdp_sa, names_from = "iso2c", values_from = "NGDP_R_K_SA_IX")
# Veja que CO e ID possuem valores apenas a partir de 2000Q1
# Os demais valores estão íntegros

# ---- DOWNLOAD DOS DADOS NÃO SAZONALMENTE AJUSTADOS E AJUSTE SAZONAL ----

# Segundo a dissertação, há países que não possuem dados sazonalmente ajustados na base. Quais?
gdp_sa_faltantes <- paises_iso[which(!paises_iso %in% gdp_sa$iso2c)]

# Mesmo processo anterior, mas para países em gdp_sa_faltantes
# Código: NGDP_R_K_IX
gdp_nsa <- surexr::ifs_data(indicator = "NGDP_R_K_IX",
                           country = gdp_sa_faltantes,
                           start = as.numeric(timespan["início"]),
                           end = as.numeric(timespan["final"]),
                           freq = "Q")
#
# # Ajuste sazonal usando pacote x12
# gdp_nsa_x12 <- x12::new(Class = "x12Single", ts = gdp_nsa, tsName = "NGDP_R_K_IX")

# ---- CÁLCULO DO CRESCIMENTO TRIMESTRAL DO PIB ----

# Para calcular o crescimento timestral do PIB conforme descrito na dissertação:
# yt = ln(GDPt) - ln(GDPt-1)
gdp_growth <- gdp_sa %>% #gdp_growth recebe inicialmente gdp_sa
  group_by(iso2c) %>% #as próximas ações serão feitas para cada grupo em iso2c
  mutate(growth = log(NGDP_R_K_SA_IX) - log(lag(NGDP_R_K_SA_IX)), .keep="unused") #cria a variável de crescimento e elimina a do produto
# a função lag do dplyr retorna o valor da linha anterior

# ---- CÁLCULO DAS ESTATÍSTICAS DESCRITIVAD DO CRESCIMENTO DO PIB ----

# Replicar tabela 1 na pág 32 da dissertação
gdp_growth_stats <- gdp_growth %>%
  group_by(iso2c) %>%
  summarise(mean = round(mean(growth, na.rm = T),5)*100,
            sd = round(sd(growth, na.rm = T),5)*100,
            min = round(min(growth, na.rm = T),5)*100,
            max = round(max(growth, na.rm = T),5)*100)
