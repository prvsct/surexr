# ----- INTRODUÇÃO ------

# Esse código realiza o download da taxa nominal de câmbio, final do período, em USD
# para os 23 países utilizados em Gonçalves e Ferreira (2020), como mostrado
# em Table 1: descriptive statistics

# Em seguida, faz análises e tratamentos

# ATENÇÃO: ANTES DE COMEÇAR, SEMPRE VERIFICAR OS PAÍSES COM load() CONFORME PRIMEIRA LINHA


# ---- CARREGAMENTO DOS PAISES ----

# Carrega a imagem de países conforme gerada por paises_iso.R
# ATENÇÃO: se houver mudanças nos países, verificar se nova versão de países_iso.R foi salva
load(file = "data//paises_iso.Rdata")

# ----- DOWNLOAD DOS DADOS ------

# Usa surexr::ifs_data para baixar a taxa nominal de câmbio em USD, fim do período, para os códigos
# ISO em paises_iso, começando em 1999 e até 2020 com frequência mensal
# ENDE_XDC_USD_RATE conforme surexr::ifs_indicators
exrate <- surexr::ifs_data(indicator = "ENDE_XDC_USD_RATE",
                           country = paises_iso,
                           start = 1999,
                           end = 2020,
                           freq = "M")

# Salva a base de dados, 70kb com 5737 obs, em exrate.Rdata
save(exrate, file = "data//exrate.Rdata")

