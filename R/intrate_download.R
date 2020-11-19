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

# ---- DEFINIÇÃO DOS CÓDIGOS ----

# Nesta seção define-se os códigos que serão utilizadoss para cada uma das
# séries.
cod_treasury_bills <- "FITB_PA"
cod_deposit_rate <- "FIDR_PA"
cod_gov_bonds <- "FIGB_PA"


# --- DOWNLOOAD DOS TREASURY BILLS ----

# Idealmente, deve-se usar treasury bill como taxa de juros

treasury_bills <- surexr::ifs_data(indicator = cod_treasury_bills,
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

paises_taxa_deposito <- c("AU", "CL", "CO", "KR", "ID", "PE", "SG", "TR", "TH")

deposit_rate <- surexr::ifs_data(indicator = cod_deposit_rate,
                                   country = paises_taxa_deposito,
                                   start = timespan["início"],
                                   end = timespan["final"],
                                   freq = "M")

# Pivotamento para checar integridade

deposit_rate_wide <- pivot_wider(deposit_rate, names_from = "iso2c", values_from = "FIDR_PA")

# --- DOWNLOAD DOS GOVERNMENT BONDS ----

# Nos casos em que não é possível usar nem taxas de depósito,
# usa-se government bonds

# Quais são esses países?

paises_gov_bonds <- c("NO","DE")

gov_bonds <- surexr::ifs_data(indicator = cod_gov_bonds,
                                 country = paises_gov_bonds,
                                 start = timespan["início"],
                                 end = timespan["final"],
                                 freq = "M")

# Pivotamento para checar integridade

gov_bonds_wide <- pivot_wider(gov_bonds, names_from = "iso2c", values_from = "FIGB_PA")

# --- SUBSTITUIÇÃO DAS SÉRIES PELAS MAIS AMPLAS ----

# Primeiro vamos remover as séries em treasury_bills que serão substituídas
# por outras
# são elas: AU. SG, TH

treasury_bills_wide <- select(.data = treasury_bills_wide, -AU,-SG,-TH)

# Vamos verificar se as variáveis em cada uma das três bases são unicas

var_finais <- c(colnames(treasury_bills_wide)[-1],
                colnames(deposit_rate_wide)[-1],
                colnames(gov_bonds_wide)[-1])

paises_iso[which(!paises_iso %in% var_finais)]

# Se não há valores repetidos em var_finais, são únicas
# Não dá dados para Suíça

# --- APPEND FINAL DAS BASES ---


# ---- TABELA COM INFORMAÇÕES DE CADA PAÍS ----

# Cria uma tabela com cada país, a taxa de juros utilizada e o período amostral

intrate_dados_descricao <- data.frame(
  "País"=character(length(paises_iso)),
  "Variável"=character(length(paises_iso)),
  "Código"=character(length(paises_iso)),
  "Amostra"=character(length(paises_iso)),
  "Frequência"=character(length(paises_iso)),
  "Observações"=character(length(paises_iso))
)

intrate_dados_descricao$País <- paises_iso

# Tipo de série utilizada
intrate_dados_descricao$Variável[intrate_dados_descricao$País %in% colnames(treasury_bills_wide)] <- "Treasury Bills"
intrate_dados_descricao$Variável[intrate_dados_descricao$País %in% colnames(deposit_rate_wide)] <- "Deposit Rate"
intrate_dados_descricao$Variável[intrate_dados_descricao$País %in% colnames(gov_bonds_wide)] <- "Government Bonds"

# Código da série utilizada
intrate_dados_descricao$Código[intrate_dados_descricao$Variável=="Treasury Bills"] <- cod_treasury_bills
intrate_dados_descricao$Código[intrate_dados_descricao$Variável=="Deposit Rate"] <- cod_deposit_rate
intrate_dados_descricao$Código[intrate_dados_descricao$Variável=="Government Bonds"] <- cod_gov_bonds

# Amostra de cada país
