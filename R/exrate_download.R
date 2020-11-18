# ----- INTRODUÇÃO ------

# Esse código realiza o download da taxa nominal de câmbio, final do período, em USD
# Os países são aqueles definidos em paises_iso.R
# O período temporal são aqueles definidos em timespan

# Em seguida, faz análises e tratamentos

# ATENÇÃO: ANTES DE COMEÇAR, SEMPRE VERIFICAR OS PAÍSES COM load() CONFORME PRIMEIRA LINHA


# ---- CARREGAMENTO DOS PAISES ----

# Carrega a imagem de países conforme gerada por definir_base.R
# ATENÇÃO: se houver mudanças nos países, verificar se nova versão de países_iso.Rdata foi salva
load(file = "data//paises_iso.Rdata")

# ---- CARREGAMENTO DO PERÍODO AMOsTRAL ----

# Carrega a imagem do período amostral conforme gerada por definir_base.R
# ATENÇÃO: se houver mudanças no período amostral, verificar se nova versão de timespan.Rdata foi salva
load(file = "data//timespan.Rdata")


# ----- DOWNLOAD DOS DADOS ------

# Usa surexr::ifs_data para baixar a taxa nominal de câmbio em USD, fim do período
# Os países são aqueles definidos em países_iso
# O período amostral é aquele definido em timespan
# É preciso assegurar que start e end sejam valores numéricos, daí o uso de as.numeric
# Analogamente para freq, que deve ser character
# ENDE_XDC_USD_RATE conforme surexr::ifs_indicators

exrate_paises_iso <- surexr::ifs_data(indicator = "ENDE_XDC_USD_RATE",
                           country = paises_iso,
                           start = as.numeric(timespan["início"]),
                           end = as.numeric(timespan["final"]),
                           freq = as.character(timespan["frequência"]))

# ---- DOWNLOAD DOS DADOS: ALEMANHA ----

# Para Alemanha, os valores de taxa de câmbio no período são os da zona do euro
# O código para a zona do euro é U2
# Checar hein: https://github.com/christophergandrud/imfr/issues/15

exrate_EA <- surexr::ifs_data(indicator = "ENDE_XDC_USD_RATE",
                           country = "U2",
                           start = as.numeric(timespan["início"]),
                           end = as.numeric(timespan["final"]),
                           freq = as.character(timespan["frequência"]))

# Substituir o U2 para DE conforme padrão dos demais códigos

exrate_EA$iso2c <- "DE"


# ---- APPEND DAS DUAS BASES ----

# Une a exrate com exrate_EA usando um append simples

exrate <- dplyr::bind_rows(exrate_paises_iso, exrate_EA)


# ---- CORTE DO PERÍODO FINAL DE 2014 ----

# Na dissertação, o período usado é de 1999T1 a 2014T2.
# Como só é possível selecionar anos cheios, é preciso remover os valores a partir de 2014T2
# Ou seja, retirar observações de 2014-07 a 2014-12
# ATENÇÃO: essa seção deve ser totalmente removida quando for rodar para o timespan mais recente

corte_2014t2 <- c("2014-07","2014-08","2014-09","2014-10","2014-11","2014-12")
exrate_2014 <- dplyr::filter(.data = exrate, !exrate$year_month %in% corte_2014t2)

# ---- SALVANDO AS BASES ----

# Salva os dois dataframes exrate e exrate_2014 em seus respectivos arquivos

save(exrate, file = "exrate.Rdata")
save(exrate_2014, file = "exrate_2014.Rdata")
