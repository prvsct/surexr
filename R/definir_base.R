# ----- INTRODUÇÃO ------

# Este código deve ser o primeiro a ser executado
# Sua função é definir a base, com países e período amostral
# Apenas nele devem ser alteradas essas informações, salvando o .Rdata para uso em outros códigos

# Neste código, e somente neste código, devem ser colocados ou retirados países para download das bases
# Sempre salvar o .Rdata com save() ao final do código

# Além disso, define o período amostral no vetor timespan, salvando para uso em outros códigos
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

# Define o período e a frequência amostral para ser utilizada nos demais códigos
# As três informações estão contidas no vetor timespan, na ordem: ano de início, ano final, frequência

# Vetor timespan
timespan <- c(1999, 2020, "M")
names(timespan) <- c("início","final","frequência")
save(timespan, file = "data/timespan.Rdata")
