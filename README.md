# Tiptoi_Dungeon

## Intro
Der Code ist ein Teil von dem Rollenspiel ("Der Schattenkönig") für den Tiptoi. Mit dem Code wird ein 10x10 Felder Spielfeld definiert auf dem man beliebig Dungeons, Höhlen, Häuser oder andere Innenräume definieren kann. Sobald man auf dem Hauptspielplan ein Dungeon betritt wechselt man auf das Dungeonspielfeld. Das Konzept sieht vor, dass der Spielplan mit einer durchsichtigen Folie (z.B. eine Klarsichthülle) abgedeckt ist und die Spieler das Dungeon schrittweise durch tippen mit dem Stift erkunden. Dabei können Mauern und wichtige Orte schrittweise mit einem abwaschbaren Stift markiert werden. Alternativ können die Dungeons mit einer Schablone markiert werden. Um es einfach zu halten kann man nur nach oben, unten, rechts und links und nicht diagonal gehen. Die Sprachausgabe für z.B die jeweilige Position kommt von dem Tiptoi Taschhenrechner 

## Konzept
Durch Tippen auf ein Feld wird eine Funktion gestartet die checkt ob man bereits auf dem Feld steht, von einem direkten Nachbarfeld kommt oder von einem weiter entfernten Feld. Dazu hat jedes Feld y und y Koordinaten und eine Nummer.

  - Gleiches Feld: Bestättigungston (Schritte) + check ob das Feld spezielle Ereignisse triggert 
  - Entferntes Feld / diagonles Feld: Warnung (zu weit weg), keine Änderung der Koordinaten 
  - Nachbarfeld: Check ob es eine Mauer gibt
    - Mauer: Warnung (kein Durchgang) keine Änderung der Koordinaten
    - Keine Mauer: Bestättigungston (Schritte) + Änderung der Koordinaten + check ob das Feld spezielle Ereignisse triggert
 
Die Mauern/Kanten werden dazu per Bit encoding in Variablen/Registern gespeichert (0 = Mauer, 1= Frei. Jede Variable kann also die Information über 16 Kanten speichern. 

<p align="center">
  <img src="https://github.com/JG55JG/Tiptoi_Dungeon/blob/main/pictures/dungeon_example.png"/>
</p>


