
# script zum erstellen von eigenen Dungeons
# funktioniert nur für das 10x10 Spielfeld das in dungeon.yaml definiert ist


# der inp vektor muss alle Felder enthalten aus denen das Dungeon bestehen soll
# z.B für das 6 Felder Dungeon aus Abbildung 1

inp<- c(1,2,3,11,12,13)

# sollen einzelne Kanten im Inneren des Dungeons geschlossen sein
# z.B die Verbindung von Feld 1 zu Feld 2
# muss man die jeweilige Kante in den closed Vektor schreiben
# Die Nomenklatur für Kanten ist "<niedrigere Feldnummer>_<höhere Feldnummer"
# also "1_2" und nicht "2_1"

closed<-c("1_2")


# laden der Kanten-Tabelle für das 10x10 Spielfeld
edge_mat<-read.csv("kanten_tabelle.txt", sep="\t")




edges<-c()
for(i in 1:length(inp)){
	
	tmp_x<-ceiling(inp[i]/y)
	tmp_y<-inp[i]-(tmp_x-1)*y
	#left
	if(tmp_y<y){
		tmp<-paste0(inp[i],"_",inp[i]+1)
		edges<-c(edges,tmp)
		print(c(inp[i],tmp))
	}
	#bottom
	if(tmp_x<x){
		tmp<-paste0(inp[i],"_",inp[i]+y)
		edges<-c(edges,tmp)
		print(c(inp[i],tmp))
	}
	#top
	if(tmp_x>1){
		tmp<-paste0(inp[i]-y,"_",inp[i])
		edges<-c(edges,tmp)
		print(c(inp[i],tmp))
	}
	#right
	if(tmp_y>1){
		tmp<-paste0(inp[i]-1,"_",inp[i])
		edges<-c(edges,tmp)
		print(c(inp[i],tmp))
	}
}


inner<-edges[which(duplicated(edges))]
outer<-setdiff( edges, inner)


inner<-edge_mat[match(inner, edge_mat[,1]),]
if(length(closed)>0){
	p<-na.omit(match(closed,inner[,1]))
	if(length(p)>0){
		inner<-inner[-p,]
	}
}


inds<-unique(inner[,2])
out<-c()
for(i in inds){
	pos<-which(inner[,2]==i)
	tmp<-paste0("$kanten_pos",i, ":=", sum(as.numeric(inner[pos,3])))
	out<-c(out,tmp)
}


# Die Variablen mit den korrekten Bit-Codes werden in einer Textdatei ausgegeben und
# können dann zum definieren eines Dungeons in dungeon.yaml verwendet werden

writeLines(out, con="dungeon.txt")
