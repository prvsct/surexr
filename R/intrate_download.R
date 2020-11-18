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
# ATENÇÃO: Alguns países possuem valores para treasury bills, mas a Fernanda prefere usar
# outras séries por possuir maior número de observações
# Essas correções serão feitas uma a uma, substituindo os valores em
# treasury_bills_wide pelos valores das séries utilizadas, na seção
# substituição

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

# Idealmente, deve-se usar treasury bill como taxa de juros

treasury_bills <- surexr::ifs_data(indicator = "FITB_PA",
                                   country = paises_iso,
                                   start = timespan["início"],
                                   end = timespan["final"],
                                   freq = "M")

# Pivotamento para checar integridade

treasury_bills_wide <- pivot_wider(treasury_bills, names_from = "iso2c", values_from = "FITB_PA")

# Quais paises não estão em treasury_bills?

treasury_bills_ausentes <- paises_iso[which(!paises_iso %in% unique(treasury_bills$iso2c))]

# Os seguintes países estão ausentes de treasury_bills:
# Switzerland
# Chile
# Colombia
# Germany
# Indonesia
# Republic of Korea
# Norway
# Peru
# Turkey

# Os seguintes países usaram séries alternativas na dissertação:
# Australia (série de taxa de depósito é mais ampla)
# Chile (taxa de depósito)
# COlombia (taxa de depósito)
# Germany (government bonds)
# Republic of Korea (taxa de depósito)
# Indonesia (taxa de depósito)
# Norway (government bonds)
# Peru (taxa de depósito)
# Singapura (série de taxa de depósito é mais ampla)
# Turkey (série de taxa de depósito é mais ampla)

# --- DOWNLOAD DAS TAXAS DE DEPÓSITO ----
#
# Nesta seção é feito o download das séries de taxa de depósito conforme
# utilizado na dissertação

# Quais são esses países?

paises_taxa_deposito <- c("AU", "CL", "CO", "KR", "ID", "PE", "SG", "TR")

# --- DOWNLOAD DOS GOVERNMENT BONDS ----

# Nos casos em que não é possível usar nem taxas de depósito,
# usa-se government bonds

# Quais são esses países?

paises_gov_bonds <- c("NO","DE")

# --- SUBSTITUIÇÃO DAS SÉRIES PELAS MAIS AMPLAS

# --- APPEND FINAL DAS BASES ---
