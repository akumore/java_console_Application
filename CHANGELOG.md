# CHANGELOG

### features/new_boardmembers
* Add new board members: A. Bult, I. Hardegger, U. Moser, T. Rüppel

### v2.2 on 2012-12-10
* New implemented stories:
    * Als Editor möchte ich eine Vorschau eines erstellten Angebots sehen können
    * Als Editor der Filialen TI und NI möchte ich Immobilien auf einen filialeigenen Homegate Account publizieren können
* Change external export to not include rent extra for working/storing real estates

### v2.1.2 on 2012-12-05
* Fix: revert list styles to basic bullets

### v2.1.1 on 2012-12-03

* Fix: Include titles for assets (images and floor plans) in exporter
* Fix: Sort options in real estate list are now persisted when returning to the list from a detail page
* Fix: Removed double line breaks after titles in the homegate description

### v2.1, Release on 2012-11-30
* Update text styling for h3, lists etc in content bricks

### v2.0, Release on 2012-11-05

* First official "Weiterentwicklung" Release, no more support stories
* New implemented stories:
    * Als Besucher möchte ich auf Homegate für Angebote im Bereich Arbeiten/Lagern den Nettopreis eines Angebots in der Übersichtsliste sehen
    * Als Besucher möchte ich auf Homegate für Mietangebote den Bruttopreis sehen

### v1.13, Release on 2012-10-25

* New implemented stories:
    * Als Besucher möchte ich eine korrekte Darstellung auf einem Device mit iOS6 sehen

### v1.12.2, Release on 2012-10-22

* Fix application form urls in gartenstadt microsite API

### v1.12.1, Release on 2012-10-18

* Fix empty appointment mails in languages other than german

### v1.12, Release on 2012-10-15

* Fix failing homepage slider spec
* Fix correct selection of active search filter tabs on real estate detail page without url params
* Fix long image titles in handout over 2 lines
* New implemented stories:
    * Als Besucher möchte ich das Anmeldeformular in der richtigen Sprache angezeigt bekommen

### v1.11.1, Release on 2012-10-10

* Fix rent_net and rent_extra rounding in idx301 export for immostreet
* Fix internal reference project link to real estate, using offer and utilization in params

### v1.11, Release on 2012-10-10

* Fix backend language beeing changed by locale parameter, must always be :de
* New implemented stories:
    * Als Editor möchte, dass meine Angebote automatisch an www.immostreet.ch exportiert werden

### v1.10, Release on 2012-10-09

* French text corrections in appointment form and handout usable surface helpt text
* Fix trailing list item not beeing rendered in idx301 export
* Fix double values for ceiling height / hall height in idx301 export
* New implemented stories:
    * Als Editor möchte ich alle CMS Texte auf Deutsch sehen
    * Als Besucher möchte ich Referenzprojekte unter Immobilienliste gefiltert nach dem aktuellen Nutzungstyp (Wohnen/Arbeiten) sehen
    * Als Editor soll die Verfügbarkeit von Garage und Parkplätzen aus der Anzahl Parkplätzen automatisiert abgeleitet werden
    * Als Besucher möchte ich den Grundriss einer Immobilie sehen, nachdem die Kartenansicht geöffnet wurde.

### v1.9.1, Release on 2012-10-04

* Fix idx301 category for unavailable secondary types
* Fix idx301 integer values

### v1.9, Release on 2012-10-04

* Add possibility to disable the video export for an export target

### v1.8.4, Release on 2012-10-04

* Adjust new FS paths, because home.ch changed them

### v1.8.3, Release on 2012-10-04

* Fixed cache path for handout pdfs

### v1.8.2, Release on 2012-10-04

* Fixed export with custom packager for home.ch

### v1.8.1, Release on 2012-10-04

* Fixed export with custom packager for immoscout

### v1.8, Released on 2012-10-04

* Fixed appointment confirmation page styling
* New implemented stories:
    * Als Editor möchte, dass meine Angebote automatisch an www.home.ch exportiert werden
    * Als Editor möchte, dass meine Angebote automatisch an www.immoscout.ch exportiert werden
    * Als Editor möchte ich ein Angebot immer gesammelt auf alle Drittwebsites publizieren

### v1.7, Released on 2012-10-03

* New implemented stories:
    * Als Benutzer möchte ich den Grundriss nicht als Google Suchresultat erhalten
    * Als Immobilienbewirtschafter möchte ich Terminanfragen neu als "Kontaktanfragen" erhalten
    * Als Google Analytics User möchte ich sehen, wie die AM Website genutzt wird
    * Als Besucher möchte ich für "Mieten/Wohnen" Angebote auf der Angebotsliste den Bruttopreis angezeigt bekommen
    * Als Besucher möchte ich am Ende der Trefferlisten-Pfeilnavigation sehen, dass keine weiteren Angebote angezeigt werden können.
    * Als Editor möchte ich nicht mehr als 50 Zeichen für Bild/Dokument-Bezeichnungen eingeben können
    * Als Besucher möchte ich die News als RSS Feed abonnieren können

### v1.6, Released on 2012-09-26

* New implemented stories:
    * Als Admin möchte ich sehen, wer ein Angebot erstellt hat
    * Als Besucher möchte ich über die Hauptnavigation direkt in Mieten/Arbeiten und Kaufen/Wohnen springen
    * Als Besucher möchte ich auf der Unternehmensseite keine Referenzprojekte sehen
    * Als Editor möchte ich andere Bezeichnungen für bestehende Objekt-Arten
    * Als Editor möchte ich Checkboxen und Radiobuttons nur aktivieren, wenn ich innerhalb des Element- und Textbereichs klicke

### v1.5, Released on 2012-09-10

* Upload generated object documentation pdf to homegate

** Older revisions are not tracked in this document **
