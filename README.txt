Copyright (c) 2010 Roman Naumann

	  This file is part of HV.
	  HV is free software: you can redistribute it and/or modify
	  it under the terms of the GNU General Public License as published by
	  the Free Software Foundation, either version 3 of the License, or
	  (at your option) any later version.

	  HV is distributed in the hope that it will be useful,
	  but WITHOUT ANY WARRANTY; without even the implied warranty of
	  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	  GNU General Public License for more details.

	  You should have received a copy of the GNU General Public License
	  along with HV.  If not, see <http://www.gnu.org/licenses/ >.

#################################################################################
			HV - DSA-Verletzungssystem
#################################################################################

This file describes a set of houserules and a utility program (HV) for
the German role-playing game "Das Schwarze Auge 4" ("The Black Eye").
Therefore, the rest of the describtion is written in German.

Bei dem DSA-Verletzungssystem handelt es sich um eine Regel-Abwandlung von DSA4,
die Trefferpunkte eleminiert. Es wird angenommen, dass sie mit Trefferzonen-
Wundregeln spielen. Wenn nicht, werden evtl. einige Abänderungen nötig sein.

Trefferpunkte sind oftmals viel zu genau. Ein Schnitt im Unterarm oder ein
angeknackstes Schienenbein lassen sich vielleich besser ohne präzise Trefferpunk-
Angaben lösen. 

Das DSA-Verletzungssystem führt die "Verletzung" ein, die in etwa einer
halben, herkömmlichen Wunde entspricht. Zudem werden Wundschwellen verringert.
Schaden kleiner-gleich der Verletzungsschwelle wird ignoriert. Das ist dann halt
nur ein oberflächlicher Schnitt oder eine vernachlässigbare Prellung, je nach
Waffe.

Das HV-Utility ist eine Konsolenanwendung, die folgendermaßen verwendet wird:
	hv <KO> <LeP> [<WS-Mod>] [zh]

Ein Aufruf (v 0.1) für eine Kriegerin mit Konstitution 15, 34 Lep und weder
Eisern noch Glasknochen als Vor/-Nachteile sieht folglich so aus:
	hv 15 34

Wäre die Kriegerin "eisern", gäben wir einen dritten Parameter an:
	hv 15 34 2

Bei Glasknochen als Nachteil statt "2" einfach "-2":
	hv 15 34 -2

Bei Zäher Hund als Vorteil muss als Parameter "zh" hinzugefügt werden:
	hv 15 34 zh

Die Reihenfolge der Parameter ist dabei wichtig. Das "zh" muss immer am Schluss
stehen.

Die Augabe für den ersten Aufruf sieht in etwa so aus:

###Ausgabe###

fmh@kira:~/workspace/hv$ hv 15 34
hv 0.1
KO:  15
LeP: 34

Schadenstabelle:
  Ab: 4         Verletzungen: 1 Wunden: 0
  Ab: 7         Verletzungen: 2 Wunden: 1
  Ab: 11        Verletzungen: 3 Wunden: 2
  Ab: 17        Verletzungen: 3 Wunden: 3
  Ab: 25        Verletzungen: 3 Wunden: 4

Aufteilung:
  Kampfbereit:  3
  Verletzt:     2
  Schwer Verl.: 0
  Fast Hinüber: 3
 Im Sterben: 3

Verletzungen Insgesamt: 8       (fkt: 4.470264317180617)

###Ende Ausgabe###

'Ab' heißt, dass ab dem angegebenen Schaden die angegebene Verletzungs-/Wund-
anzahl auftritt. Wird die Kriegerin etwa mit 10 Schaden getroffen, bekommt sie
eine Wunde in der entsprechenden Zone und zwei Verletzungen.

Weiter unten ist die Verteilung dieser Verletzungen. Im Grunde DSA-Üblich
mit 1/2, 1/3 und 1/4 Schwellen, nur dass es nicht mehr heißt, 'unter 1/2',
sondern 'kleiner-gleich 1/2'. Die Verletzungen sind so verteilt, dass erst die
entsprechenden Mali erst zur Geltung kommen, sobald mindestens eine Verletzung der
Reihe 'geschlagen' ist.
Es empfielt sich, einfach eine entsprechende Zahl an Kästchen auszuzeichnen für
jeder der Reihen (Kampfbereit/Verletzt/Schwer Verletzt/Fast Hinüber/Im Sterben).
Wenn eine Verletzung entsteht, streicht man das Kästchen durch.

Noch weiter unten steht die Gesamt-Verletzungsanzahl, die unsere Kriegerin erträgt,
ohne ihm sterben zu liegen.

Sind alle Kästchen bei 'Nahezu Hinüber' durchgestrichen, wird das wie die DSA-
übliche Kampfunfähigkeit bei 1-5 LeP behandelt: Betroffener ist nur noch in der
Lage sich mit GS-1 fortzubewegen und kann keine weiteren Aktionen ausführen.

Wird noch mehr Schaden eingesteckt, schwinden die Kästchen unter 'im Sterben'.
Der Held ist i.d.R. ohnmächtig und liegt im Sterben. Er stirbt DSA-üblich in-
nerhalb von W6*KO Kampfrunden. Der Spannung halber sollte der Spielleiter dies
auswürfeln.

Wenn alle Kästchen unter 'im Sterben' weg sind, ist der Held auf der Stelle
tot.


Nicht tötlicher Schaden, in DSA4 als TP(A) bezeichnet, wird ähnlich behandelt.
Wenn ein Kämpfer TP(A) anrichtet, werden wie üblich Wunden und Verletzungen er-
mittelt. Wunden kommen wie üblich zum Tragen, es ist aber nicht möglich, Körper-
teile durch Wunden aus TP(A) abzuschlagen oder jdm. zu töten.
Wundschwellen werden nicht reduziert. (TP(A) sind i.d.R. schon klein genug)
Die ermittelten Verletzungen werden halbiert. Die (abgerundete) Hälfte sind nicht-
tötliche Verletzungen, für die Kästchen nicht durchgestrichen sondern umkreist
werden. Die (abgerundete) Hälfte sind normale Verletzungen.

Sonderfall 1:
Liegt ein Held mit m nichttötlichen Verletzungen im Sterben mit n Sterbekästchen
durchgestrichen, ist er nur ohnmächtig und nicht 'im Sterben', so lange n >= m ist.

Sonderfall 2:
Erleidet ein Held (mit min. einer nichttötlichen Verletzung und all seinen Kästchen
durchgestrichen oder umkreist) eine weitere (tötliche oder nichttötliche) Ver-
letzung, streicht er die umkreisten Verletzungen durch.


Heilregeln:
Hier besteht sicher noch Verbesserungsbedarf, aber solange in der Gruppe keine Hel-
den mit einer Konstitution >17 sind, sollte folgende (einfache) Regel genügen:
Jede Nacht unter vernünftigen Bedingungen heilt ein Held eine Verletzung, egal ob
tötlich oder nichttötlich. Es wird von unten nach oben wegradiert. In einer Reihe
je nichttötliche Verletzungen zuerst.

Alternative hierzu:
    Ein W6 entspricht  einer Verletzung, damit können die Heilungsregeln aus WdS
    ohne großen Aufwand übernommen werden. Für xW6+u gilt, dass x Verletzungen ge-
    heilt werden und bei einer 1-u auf dem W6 eine weitere. yW6-v => y-1 geheilt,
    bei v-6 auf W6 eine weitere Verletzung.

Für Wundheilung gelten eins zu eins die Regeln aus WdS.

Magische Heilung: Je 3.5 eigentlich geheilte Punkte heilen eine Verletzung. Ein Bal-
sam kostet - um 3 Verletzungen zu heilen - also 11 AsP, für zwei Verletzungen 7 und
für eine immer noch 4. (Sie können für übrige geheilte LeP die Alternativregeln von
Oben anwenden)

#################################################################################
			Berechnungsdetails
#################################################################################

Um die Berechnungsdetails zu verstehen, schaut man am besten in die Main.hs
Datei. Der Quellcode ist teilweise Kommentiert und im Wesentlichen Selbsterklärend.
(Auch wenn Leider in Teilen zu viel für den Großteil unverständliches Higher-
Order-Mess drin ist)
