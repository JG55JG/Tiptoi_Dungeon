# Tiptoi_Dungeon
+++++ Bugs wahrscheinlich +++++

## Übersicht

- [Intro](#Intro)
- [Konzept Spielfeld](#Konzept-Spielfeld)
- [Konzept Gegner](#Konzept-Gegner)
- [Dungeon Beispiele](#Beispiele)
   - [Dungeon 1 (einfaches Bewegungsbeispiel)](#Dungeon-1-(einfaches-Bewegungsbeispiel))
   - [Dungeon 2 (einfaches Rätselbeispiel)](#Dungeon-2-(einfaches-Rätselbeispiel))
- [How-to zum erstellen von eigenen Dungeons](#How-to-zum-erstellen-von-eigenen-Dungeons)
- [Teaser "Der Schattenkönig"](#Teaser-"Der-Schattenkönig")
  - [Story](#Story)
    - [Hintergrundgeschichte](#Hintergrundgeschichte)

## Intro
Der Code ist ein Teil von dem Rollenspiel ("Der Schattenkönig") für den Tiptoi. Mit dem Code wird ein 10x10 Felder Spielfeld definiert auf dem man beliebig Dungeons, Höhlen, Häuser oder andere Innenräume definieren kann. Sobald man auf dem Hauptspielplan ein Dungeon betritt wechselt man auf das Dungeonspielfeld. Das Konzept sieht vor, dass der Spielplan mit einer durchsichtigen Folie (z.B. eine Klarsichthülle) abgedeckt ist und die Spieler das Dungeon schrittweise durch tippen mit dem Stift erkunden. Dabei können Mauern und wichtige Orte mit einem abwaschbaren Stift markiert werden. Alternativ können die Dungeons mit einer Schablone markiert werden. Um es einfach zu halten kann man nur nach oben, unten, rechts und links und nicht diagonal gehen. Die Sprachausgabe für Zahlen (z.B für die jeweilige Position) stammt aus dem [Tiptoi Taschenrechner](https://bitbucket.org/nomeata/tiptoi-taschenrechner/src/master/) von Joachim Breitner. Das Rollenspielprojekt befindet sich noch in einer pre Alpha-Version und es gibt bis jetzt nur "Text-To-Speech" Audiodateien.

## Konzept Spielfeld
Durch Tippen auf ein Feld wird eine Funktion gestartet die checkt ob man bereits auf dem Feld steht, von einem direkten Nachbarfeld oder von einem weiter entfernten Feld kommt. Dazu hat jedes Feld x und y Koordinaten und eine Nummer.

  - Gleiches Feld: Bestättigungston (Schritte) + check ob das Feld spezielle Ereignisse triggert 
  - Entferntes Feld / diagonales Feld: Warnung (zu weit weg), keine Änderung der Koordinaten 
  - Nachbarfeld: Check ob es eine Mauer gibt
    - Mauer: Warnung (kein Durchgang) keine Änderung der Koordinaten
    - Keine Mauer: Bestättigungston (Schritte) + Änderung der Koordinaten + check ob das Feld spezielle Ereignisse triggert
 
Die Mauern/Kanten werden dazu per Bit encoding in Variablen/Registern gespeichert (0 = Mauer, 1= Frei). Jede Variable kann also die Information über 16 Kanten speichern. Die Zählung fängt dabei rechts oben an. Bei einem 10x10 Feld ist Kante 1 die Kante zwischen Feld 1 und Feld 2 (siehe Abbildung 1) und Kante 2 die Kante zwischen Feld 1 und Feld 11. Für das 6 Felder Dungeon in Abbildung 1 (markiert mit schwarzem Rahmen) müssen die Kanten 1 bis 6 im "roten" Kantenregister freigestellt werden und die Kanten 4, 6 und 8 im "blauen" Kantenregister. Mit bitwise AND wird dann gecheckt ob eine Kante frei ist oder nicht.

```
# 1= 2^0 = 1, 2 = 2^1 = 2, 3 = 2^2 = 4 ,4 = 2^3 = 8, 5= 2^4 = 16, 6 = 2^5 = 32
$Kante_rot := 63

# 4 = 2^3 =8, 6= 2^5 = 32, 8 = 2^7 = 128
$Kante_blau := 168

# check ob Kante 4 in $Kante_rot frei ist
$test :=  $Kante_rot $test &= 8
$test >0? # Kante offen
$test == 0? # Kante zu

```

<p align="center">
  <img src="https://github.com/JG55JG/Tiptoi_Dungeon/blob/main/pictures/dungeon.example2.png"/ width="35%" >
</p>
<sub>Abbildung 1: Beispiel für Kantenkodierung
</sub>

## Konzept Gegner 
In einem Dungeon kann ein einzelner Gegner auftauchen, der sich immer in Richtung des Spielers bewegt. Eine einfache Wegfindung sorgt dafür, dass der Gegner nicht durch Wände läuft (dafür nimmt sich der Tiptoi allerdings ein paar Gedenksekunden), und immer zuerst in die Richtungachse geht, auf der er die größte Distanz zum Spieler hat (bei gleicher Distanz entscheidet der Zufall). Das Kampfsystem des Rollenspiels ist in diesem Dungeon-Beispiel nicht integriert. Die Position des Gegners wird am besten mit einem Plättchen oder einer Spielfigur dargestellt. 

## Beispiele
In diesem Code sind 2 Dungeonbeispiele integriert. 

### Dungeon 1 (einfaches Bewegungsbeispiel)
Das Dungeon wird durch das tippen auf das "Dungeon 1" Feld gestartet. Das Dungeon ist nur zum ausprobieren der Bewegung und der Gegner Wegfindung gedacht. Start ist Feld 1, sobald man auf Feld 2 tritt erscheint eine Ratte auf Feld 50. Nach jedem Spielerzug startet automatisch der Zug des Gegners (dauert etwas) mit der Ansage in welche Richtung der Gegner geht.

**Kanten Variablen für Dungeon1:**
```
$kanten_pos1:=4085 $kanten_pos2:=24448 $kanten_pos3:=64512 $kanten_pos4:=41471 
$kanten_pos5:=3770 $kanten_pos6:=4224 $kanten_pos7:=1504 $kanten_pos8:=1792
$kanten_pos9:=512 
```


<p align="center">
  <img src="https://github.com/JG55JG/Tiptoi_Dungeon/blob/main/pictures/dungeon.example.png"/ width="35%" >
</p>
<sub>Abbildung 2: Dungeon 1
</sub>

### Dungeon 2 (einfaches Rätselbeispiel)
Für Dungeon 2 ist kein Karte vorgegeben. Start ist auf Feld 61. Das Ziel ist den Schatz auf Feld 45 zu holen und ihn zurück zum Start zu bringen ohne von der Höhlenratte erwischt zu werden.

## How to zum erstellen von eigenen Dungeons

## Teaser "Der Schattenkönig"
Hier noch ein paar Infos zum finalen Rollenspiel. Alle Mechaniken sind schon programmiert und das 1. Kapitel ist hoffentlich bald fertig.
### Story
#### Hintergrundgeschichte
Vor langer Zeit lebten die Menschen friedlich und glücklich in einem kleinen Königreich. Doch die Frau des Königs starb an einer geheimnisvollen Krankheit und ließ zwei Kinder, Tami und Ora sowie den gütigen König allein zurück. Nach einiger Zeit erkrankte auch Ora an der Krankheit. Der König, der auch ein gelehrter Magier war, versuchte alles um sein Kind zu retten. Ora wurde immer kränker und er Vater immer verzweifelter. Als die Lage aussichtslos erschien, versuchte er sich schließlich an dunkler, verbotener Magie. Doch anstatt Ora zu retten geriet er in den Bann des Bösen und verfluchte sein ganzes Land und Ora zu einem ruhelosen Leben als Geisterwesen, den Schatten, halb im Land der Lebenden, halb im Land der Toten. Er selbst verfiel dem Bösen. In einem letzten Moment der Menschlichkeit erinnerte sich der König daran, dass er eigentlich nur seine Familie schützen wollte und legte sein zweites Kind Tami in einen langen Zauberschlaf der es vor allem Unheil bewahrte. Seitdem sind viele Jahrhunderte vergangen und an das alte Königreich kann sich niemand mehr erinnern. Nicht einmal Ruinen haben die Zeit überdauert.
An der Stelle der Königsburg steht heute ein kleines Gehöft. Dort lebt ein Bauernpaar das ein Waisenkind aufgenommen hat, das sie in einer nahen Höhle gefunden hatten. Der Name des Kindes ist Tami.

#### Intro für Spieler
Du lebst mit deinen Eltern auf einem kleinen Bauernhof in einem fruchtbaren Tal. Es ist ein hartes aber glückliches Leben – während des Tages. Doch sobald die Sonne untergegangen ist erheben sich die Schatten, Geisterwesen schweben körperlos durch das Land und unterhalten sich wispernd in einer unbekannten Sprache. Zu dieser Zeit verstecken sich alle Menschen in ihren Häusern und schützen sich mit magischen Talismanen und Kräutern. Als wäre das noch nicht genug wuchs kurz vor deiner Geburt eine undurchdringliche Hecke um das Tal. Seit dieser Zeit hat kein Fremder mehr das Tal betreten und auch kein Bewohner des Tals dieses verlassen. Für dich ist das jedoch alles ganz normal, du kennst es ja nicht anders. Keiner kennt das Tal besser als du.

### Spielmechaniken
- "Große" Rollenspielwelt mit mehreren Regionen, Hexfeld basiert.
- Abspeichern und laden aller Fortschritte, Positionen, gefunden Gegenstände u.s.w
- Zeitsystem mit Tag und Nachtrythmus. Nachts kann sich die Welt ändern. Manche Ereignisse finden nur zu einer definierten Zeit statt.
- Gegenstände und Werkzeugsystem. Mehrere Gegenstände können zu einem neuen Gegenstand kombiniert werden
- Würfelwurf basiertes Kampfsytem das mit Spezialattacken kombiniert wird. Für eine Spezialattacke gibt der Gegner eine zufällige bis zu 5 teilige Bewegungsserie vor (ala Simon says) die in einem einstellbaren Zeitintervall nachgetippt werden muss.
- Zauber und Spezialfertigkeiten System. Für Zauber müssen Zaubersprüche (Symbolserien) gelernt und eingegeben werden. 
- Rätseldungeons, Minispiele (Schere-Stein-Papier, Mastermind, Angeln, usw)
