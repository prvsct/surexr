# ----- INTRODUÇÃO ------

# Este código deve ser o primeiro a ser executado
# Sua função é definir a base, com países e período amostral
# Apenas nele devem ser alteradas essas informações, salvando o .Rdata para uso em outros códigos

# Neste código, e somente neste código, devem ser colocados ou retirados países para download das bases
# Sempre salvar o .Rdata com save() ao final do código

# Além disso, define o período amostral em ano_inicio, ano_final e frequencia, salvando para uso em outros códigos
# Somente neste código devem ser alterado o período amostral
# Sempre salvar o .Rdata com save() ao final do código

# ---- PAÍSES ----

# Copia e cola os nomes da tabela 1 em um vetor paises
# Substitui Korea por "Korea, Republic of" conforme necessário
paises <- c("Australia",
            "Brazil",
            "Canada",
            "Chile",
            "Colombia",
            "Germany",
            "Hungary",
            "Indonesia",
            "Israel",
            "Japan",
            "Korea, Republic of",
            "Mexico",
            "New Zealand",
            "Norway",
            "Peru",
            "Singapore",
            "South Africa",
            "Sweden",
            "Switzerland",
            "Thailand",
            "Turkey",
            "United Kingdom",
            "United States")

# Converte paises em paises_iso usando surexr::iso_converter
paises_iso <- surexr::iso_converter(names = paises)
paises_iso #checando

# Salva .Rdata
save(paises_iso, file = "data/paises_iso.Rdata")

# ---- PERIODO DE ANALISE E FREQUENCIA -----

# Define o período e a frequência amostral para ser utilizada nos demasi códigos

# Ano de inicio da análise
ano_inicio <- 1999
save(ano_inicio, file = "data/ano_inicio.Rdata")

# Ano final da análise
ano_final <- 2014
save(ano_final, file = "data/ano_final.Rdata")

# Frequência
frequencia <- "M"
save(frequencia, file = "data/frequencia.Rdata")
