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
# ATENÇÃO: antes de rodar verificar o conteúdo de paises_iso e timespan

# ---- CARREGAMENTO DOS PAISES ----

# Carrega a imagem de países conforme gerada por definir_base.R
# ATENÇÃO: se houver mudanças nos países, verificar se nova versão de países_iso.Rdata foi salva
load(file = "data//paises_iso.Rdata")

# ---- CARREGAMENTO DO PERÍODO AMOsTRAL ----

# Carrega a imagem do período amostral conforme gerada por definir_base.R
# ATENÇÃO: se houver mudanças no período amostral, verificar se nova versão de timespan.Rdata foi salva
load(file = "data//timespan.Rdata")


# --- DOWNLOOAD DOS TREASURY BILLS ----

treasury_bills <- surexr::ifs_data(indicator = "FITB_PA",
                                   country = paises_iso,
                                   start = timespan["início"],
                                   end = timespan["final"],
                                   freq = "M")

# Pivotamento para checar integridade

treasury_bills_wide <- pivot_wider(treasury_bills, names_from = "iso2c", values_from = "FITB_PA")

# Quais paises não estão em treasury_bills?

treasury_bills_ausentes <- paises_iso[which(!paises_iso %in% unique(treasury_bills$iso2c))]
