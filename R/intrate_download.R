library(tidyverse)

# ---- INTRODUÇÃO ----
#
# Esse código realiza o download da taxa de juros
# para os 23 paises de paises_iso e no período de timespan
#
# Ordem de preferência para o tipo de dado conforme a dissertação
# 1) Treasury bills
# 2) Taxas de depósito
# 3) Government bonds
#
# No código, serão baixada para todos os países as três séries, cada uma
# em uma base de acordo com paises_iso, timespan e o código definido na seção
# de código. Após o download, serão verificados quais as melhores séries para
# cada país, de acordo com o número de observações, a presença de valores
# recentes e a ordem de preferência acima.
#
# ATENÇÃO: antes de rodar verificar o conteúdo de paises_iso e timespan

# ---- CARREGAMENTO DOS PAISES ----

# Carrega a imagem de países conforme gerada por definir_base.R
# ATENÇÃO: se houver mudanças nos países, verificar se nova versão de países_iso.Rdata foi salva
load(file = "data//paises_iso.Rdata")

# ---- CARREGAMENTO DO PERÍODO AMOSTRAL ----

# Carrega a imagem do período amostral conforme gerada por definir_base.R
# ATENÇÃO: se houver mudanças no período amostral, verificar se nova versão de timespan.Rdata foi salva
load(file = "data//timespan.Rdata")

# ---- DEFINIÇÃO DOS CÓDIGOS ----

# Nesta seção define-se os códigos que serão utilizadoss para cada uma das
# séries.
cod_treasury_bills <- "FITB_PA"
cod_deposit_rate <- "FIDR_PA"
cod_gov_bonds <- "FIGB_PA"


# --- DOWNLOAD DOS TREASURY BILLS ----

# Idealmente, deve-se usar treasury bill como taxa de juros

treasury_bills <- surexr::ifs_data(indicator = cod_treasury_bills,
                                   country = paises_iso,
                                   start = timespan["início"],
                                   end = timespan["final"],
                                   freq = "M")

# Pivotamento para checar integridade

treasury_bills_wide <- pivot_wider(treasury_bills, names_from = "iso2c", values_from = "FITB_PA")

# --- DOWNLOAD DAS TAXAS DE DEPÓSITO ----

deposit_rate <- surexr::ifs_data(indicator = cod_deposit_rate,
                                   country = paises_iso,
                                   start = timespan["início"],
                                   end = timespan["final"],
                                   freq = "M")

# Pivotamento para checar integridade

deposit_rate_wide <- pivot_wider(deposit_rate, names_from = "iso2c", values_from = "FIDR_PA")

# --- DOWNLOAD DOS GOVERNMENT BONDS ----

gov_bonds <- surexr::ifs_data(indicator = cod_gov_bonds,
                                 country = paises_iso,
                                 start = timespan["início"],
                                 end = timespan["final"],
                                 freq = "M")

# Pivotamento para checar integridade

gov_bonds_wide <- pivot_wider(gov_bonds, names_from = "iso2c", values_from = "FIGB_PA")

# --- SALVAR AS SÉRIES NOS RESPECTIVOS ARQUIVOS ----

# Treasury bills
save(treasury_bills, file = "data//treasury_bills.Rdata")

# Deposit rate
save(deposit_rate, file = "data//deposit_rate.Rdata")

# Gov bonds
save(gov_bonds, file = "data//gov_bonds.Rdata")
