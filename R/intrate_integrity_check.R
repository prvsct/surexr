# --- INTRODUÇÃO ---
#
# Esse código constrói uma tabela para a taxa de juros que exibe qual série foi utilizada,
# o período amostral e o número de observações para cada país.
#
# Em seguida, monta a base final com as séries selecionadas para a taxa de juros para cada país.
#
# ATENÇÃO: antes de começar, verificar se as bases corretas foram salvas em intrate_download.R

# ---- CARREGAMENTO DAS BASES E PIVOTAMENTO ----

# Lista completa de paises
load(file = "data//paises_iso.Rdata")

# Treasury bills
load(file = "data//treasury_bills.Rdata")

# Deposit rate
load(file = "data//deposit_rate.Rdata")

# Gov Bonds
load(file = "data//gov_bonds.Rdata")

# --- CRIAÇÃO DOS DATAFRAMES POR PAÍS DENTRO DE UMA LISTA ----

# Criação da lista vazia
paises_juros <- list()

for(i in 1:length(paises_iso)){

  # Criação de dataframe com o país selecionado de treausury_bills
  # Primeiro aux_treasury recebe treasury_bills %>%
  # Então faz o pivotamento para separar por cada coluna de país %>%
  # Em seguida seleciona a coluna year_month e a coluna referente ao paises_iso[i]
  # Renomeia os nomes das colunas do df para possibilitar o join
  aux_treasury <- treasury_bills %>%
    pivot_wider(names_from = "iso2c", values_from = colnames(treasury_bills)[3]) %>%
    select(year_month, all_of(paises_iso[i]))
  colnames(aux_treasury) <- c("year_month", paste0(paises_iso[i],"_treasury"))

  # Procedimentos analogos:

  aux_deposit <- deposit_rate %>%
    pivot_wider(names_from = "iso2c", values_from = colnames(deposit_rate)[3]) %>%
    select(year_month, all_of(paises_iso[i]))
  colnames(aux_deposit) <- c("year_month", paste0(paises_iso[i],"_deposit"))

  aux_gov <- gov_bonds %>%
    pivot_wider(names_from = "iso2c", values_from = colnames(gov_bonds)[3]) %>%
    select(year_month, all_of(paises_iso[i]))
  colnames(aux_gov) <- c("year_month", paste0(paises_iso[i],"_gov"))

  # O elemento [[i]] de paises_juros recebe o join das três bases acima:

  paises_juros[[i]] <- aux_treasury %>%
    inner_join(aux_deposit) %>%
    inner_join(aux_gov)

}

# PROBLEMA: o código dá erro quando tenta selecionar colunas que não existem
# quando o dado não existe para aquela série. O que fazer? Soluções
# 1) criar colunas em todos os dfs de forma que quando não exista uma série pra certo país
# o dataframe daquele país tenha uma coluna com apenas NA
# 2) checar se a coluna existe no df antes de fazer o select com uma if clause



