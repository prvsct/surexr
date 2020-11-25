library(tidyverse)

# --- INTRODUÇÃO ----
#
# Esse código realiza o ajuste sazonal das séries não sazonalmente ajustadas e então faz o append dos dois
# dataframes. Em seguida, calcula a taxa de crescimento do PIB.
#
# ATENÇÃO: verficiar se as bases foram corretamente carregadas

# ---- CARREGAMENTO DAS BASES E DOS PAISES ----

# Lista de países
load("data//paises_iso.Rdata")

# GDP já ajustado
load("data//gdp_sa.Rdata")

# GDP ainda não ajustado
load("data//gdp_nsa.Rdata")

# --- ISOLANDO AS SÉRIES NÃO AJUSTADAS EM OBJETOS SEPARADOS ---

# PE
pe_nsa <-gdp_nsa %>%
  pivot_wider(names_from = "iso2c", values_from = colnames(gdp_nsa)[3]) %>%
  select(year_quarter,PE) %>%
  na.omit

# TR
tr_nsa <- gdp_nsa %>%
  pivot_wider(names_from = "iso2c", values_from = colnames(gdp_nsa)[3]) %>%
  select(year_quarter,TR) %>%
  na.omit

# Gerando arquivos .xlsx a partir delas
writexl::write_xlsx(x = pe_nsa, path = "C:\\Pedro Roveri Scatimburgo\\Outputs\\pe_nsa.xlsx")
writexl::write_xlsx(x = tr_nsa, path = "C:\\Pedro Roveri Scatimburgo\\Outputs\\tr_nsa.xlsx")

# --- AJUSTE SAZONAL ----
# ATENÇÃO: PARTE MANUAL QUE EXIGE CONEXÃO COM A INTERNET -> PACOTE NÃO ESTÁ FUNCIONANDO NO R 4.0
# O ajuste sazonal é feito pela interface gráfica http://www.seasonal.website/
# Os arquivos gerados acima são usados como inputs e os outputs são carregados abaixo:

pe_sa <- readxl::read_excel(path = "C:\\Pedro Roveri Scatimburgo\\Dados\\seasonal_website\\pe_sa.xlsx")
tr_sa <- readxl::read_excel(path = "C:\\Pedro Roveri Scatimburgo\\Dados\\seasonal_website\\tr_sa.xlsx")


# --- APPEND FINAL DAS BASES ----



# --- CÁLCULO DA TAXA DE CRESCIMENTO ----

# ---- SALVAMENTO ----

