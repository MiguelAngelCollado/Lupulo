library(readr)
library(ggplot2)
library(dplyr)

Lupulostats <- read_csv("Lupulostats.csv")
head(Lupulostats)
#Lista de países que producen lúpulo
unique(Lupulostats$Area)

#China está repetido, China y China mainland son lo mismo
A<-subset(Lupulostats, subset = (Lupulostats$Area=="China, mainland"))
head(A)

#Value se mide en toneladas, R ha pìllado "t" como "TRUE"

#vemos si hay 0 o NA en el dataframe
Lupulostats$Value==0
is.na(Lupulostats)
#Lo que interesa es la variable Value
is.na(Lupulostats$Value)
Lupulostats[!complete.cases(Lupulostats$Value), ]


lupulo<-data.frame(Lupulostats$Area, Lupulostats$Item, Lupulostats$Year, Lupulostats$Value, Lupulostats$`Flag Description`)
head(lupulo)
names(lupulo)<-c("Country","Crop","Year","Value.t","Description")

#China está repetido, China y China mainland son lo mismo, eliminamos China, perdón camarada Xi
lupulo<-subset(lupulo,subset = (!lupulo$Country=="China, mainland"))

#Ethiopía cuidao, lo que cultivan es Rhamnus prinoides para su cerveza etíope
#hay que quitarlos porque no es lúpulo Humulus lupulus
lupulo<-subset(lupulo,subset = (!lupulo$Country=="Ethiopia"))

#Gráfico con la producción mundial por toneladas de lúpulo
# Gráfico de evolución de Value.t por Year, agrupado por Country
ggplot(lupulo, aes(x = Year, y = Value.t, color = Country, group = Country)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Evolución de la Producción de Lúpulo por País",
    x = "Año",
    y = "Valor (Toneladas)",
    color = "País"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "right"
  )


ggplot(lupulo, aes(x = Year, y = Value.t, fill = Country)) +
  geom_col() +
  labs(
    title = "Producción Total de Lúpulo por Año",
    x = "Año",
    y = "Valor (Toneladas)",
    fill = "País"
  ) +
  theme_minimal()


# Paso 1: Identificar los 5 países que más lúpulo producen (por producción total)
top10_paises <- lupulo %>%
  group_by(Country) %>%
  summarise(total_produccion = sum(Value.t, na.rm = TRUE)) %>%
  arrange(desc(total_produccion)) %>%
  head(10) %>%
  pull(Country)

top10_paises

top5_paises <- lupulo %>%
  group_by(Country) %>%
  summarise(total_produccion = sum(Value.t, na.rm = TRUE)) %>%
  arrange(desc(total_produccion)) %>%
  head(5) %>%
  pull(Country)


# Paso 2: Crear una nueva columna categorizando países
lupulo_categorizado <- lupulo %>%
  mutate(Country_cat = ifelse(Country %in% top5_paises, Country, "Otros"))

# ============================================
# GRÁFICO 1: Barras apiladas (Top 5 + Otros)
# ============================================
ggplot(lupulo_categorizado, aes(x = Year, y = Value.t, fill = Country_cat)) +
  geom_col() +
  labs(
    title = "Producción Total de Lúpulo por Año (Top 5 países + Otros)",
    x = "Año",
    y = "Valor (Toneladas)",
    fill = "País"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# ============================================
# GRÁFICO 2: Líneas (Solo Top 5 países)
# ============================================
lupulo_top5 <- lupulo %>%
  filter(Country %in% top5_paises)

ggplot(lupulo_top5, aes(x = Year, y = Value.t, color = Country, group = Country)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Evolución de la Producción de Lúpulo por País (Top 5)",
    x = "Año",
    y = "Valor (Toneladas)",
    color = "País"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "right"
  )
