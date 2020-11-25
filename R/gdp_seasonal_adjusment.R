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


# --- TRANSFORMAÇÃO DAS SÉRIES AJUSTADAS NO FORMATO DO IFS ----
#
# Precisamos fazer com que pe_sa e tr_sa estejam no mesmo formato de gdp_sa

# PE
pe_sa_ifs <- pe_sa %>%
  select(time,adjusted)
colnames(pe_sa_ifs) <- c("year_quarter",colnames(gdp_sa)[3])
pe_sa_ifs$iso2c <- "PE"
pe_sa_ifs$year_quarter <- str_replace(string = pe_sa_ifs$year_quarter, pattern = ":", replacement = "-Q")
pe_sa_ifs <- pe_sa_ifs[,c(3,1,2)]

# TR
tr_sa_ifs <- tr_sa %>%
  select(time,adjusted)
colnames(tr_sa_ifs) <- c("year_quarter",colnames(gdp_sa)[3])
tr_sa_ifs$iso2c <- "TR"
tr_sa_ifs$year_quarter <- str_replace(string = tr_sa_ifs$year_quarter, pattern = ":", replacement = "-Q")
tr_sa_ifs <- tr_sa_ifs[,c(3,1,2)]

# --- APPEND FINAL DAS BASES
#
# Appenda com bind_rows tr_sa_ifs, pe_sa_ifs e gdp_sa em gdp

gdp <- bind_rows(gdp_sa,tr_sa_ifs,pe_sa_ifs)

# Pivotamento para checar integridade
gdp_wide <- pivot_wider(data = gdp, names_from = "iso2c", values_from = colnames(gdp)[3])

# --- CÁLCULO DA TAXA DE CRESCIMENTO ----
#
# Cálcula a taxa de crescimento do PIB usando da função lag do dplyr

gdp_growth <- gdp %>%
  group_by(iso2c) %>%
  mutate(growth = log(NGDP_R_K_SA_IX) - lag(log(NGDP_R_K_SA_IX)))

# ---- SALVAMENTO ----

save(gdp_growth, file = "data//gdp_growth.Rdata")

