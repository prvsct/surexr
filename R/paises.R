# ----- INTRODUÇÃO ------

# Neste código, e somente neste código, devem ser colocados ou retirados países para download das bases
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
