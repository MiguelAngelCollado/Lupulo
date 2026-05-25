library(readr)
Lupulostats <- read_csv("Lupulostats.csv")
head(Lupulostats)
#Lista de países que producen lúpulo
unique(Lupulostats$Area)
A<-subset(Lupulostats, subset = (Lupulostats$Area=="Democratic People's Republic of Korea"))
head(A)

#vemos si hay 0 o NA en el dataframe
Lupulostats$Value==0
is.na(Lupulostats)
#Lo que interesa es la variable Value
is.na(Lupulostats$Value)
Lupulostats[!complete.cases(Lupulostats$Value), ]


lupulo<-data.frame(Lupulostats$Area, Lupulostats$Item, Lupulostats$Year, Lupulostats$Value, Lupulostats$`Flag Description`)
head(lupulo)
names(lupulo)<-c("Country","Crop","Year","Value.t","Description")
#Value se ide en toneladas, R ha pìllado "t" como "TRUE"
View(lupulo)
