# CHANGELOG

### v2.5.3 in development
* New implemented stories:
  * #1843 Als Editor möchte ich Parkplätze ohne Beschreibung auf externe Portale exportieren können

### v2.5.2 on 2013-07-11
* New implemented stories:
  * #1301 - Als Besucher möchte ich emotionale Bilder auf der Unternehmensseite für die restlichen Kategorien sehen

* Additional Fixes
  * Board Of Director Images Update (Adrian Bult, Ida Hardegger & Ulrich
    Moser)

### v2.5.1 on 2013-07-10
* New implemented stories:
  * #1683 - Als Editor möchte ich «Distanzen in Meter» löschen können
  * #1732 - Als Besucher und Leser möchte ich die richtigen Infos im «Immobilieninfos» Akkordeon sehen

* Additional Fixes
  * RMagick gem update

### v2.5.0 on 2013-07-05
* New implemented stories:
  * #1583 - Als Editor möchte ich die Jobs per drag-n-drop sortieren können
  * #1494 - Als Editor möchte ich beim Erfassen einer Immobilie auswählen können, welche Microsite (Gartenstadt, Feldpark, Bünzpark) hinterlegt ist
  * #1495 - Als Entwickler möchte ich ein spezifisches JSON anhand eines Parameters pro Microsite generieren können

* Additional Fixes
  * Additional microsite properties building_key (Hausnummer), and property_key (Immobiliennummer).
  * Migration for Gartenstadt items

### v2.4.5 on 2013-07-01
* Implemented hotfixes:
  * Als Besucher möchte ich Viktor Naumann nicht mehr unter dem Tab «Geschäftsleitung» sehen.

### v2.4.4 on 2013-06-26
* Implemented hotfixes:
  * #1553 - Als Besucher möchte ich das neue Logo sehen

### v2.4.3 on 2013-06-24
* Implemented hotfixes:
  * #1520 - Als Immoscout24 möchte ich eine korrekt formatierte Liste erhalten

### v2.4.2 on 2013-06-13
* Fix Handout footer, logo only
* Use forked version of pdfkit
* Use @type-face integration for font rendering in handouts
* Little improvements for reference projects
* Cherry-pick english image movie
* Disable home.ch providers due expired contract

### v2.4.1 on 2013-05-22
* Fix footer link for magazine

### v2.4.0 on 2013-05-21
* Feature 1 - Lagern als zusätzliche Gebäudenutzungen
* Feature 2 - Parkieren als zusätzliche Gebäudenutzungen
* Feature 3 - Ausbau für die zusätzlichen Gebäudenutzungen "Lagern" und "Parkieren"
* Feature 4 - Angebotsliste auf der Webseite
* Feature 8 - Erweiterte Angaben zur Nutz-, Wohn- und Lagerflächen
* Feature 28 - Erweiterung Bauen
* Feature 29 - Seite "Referenzen"
* Feature 30 - Neuverortung "Forum"-Magazin

### v2.3.6 on 2013-05-14
* Hotfix: Floor field of Figure model is now mandatory in any of the utilizations
* Cherrypick rake task for printing invalid real estates

### v2.3.5 on 2013-03-22
* Hotfix: Change images for Christoph Müller, David Hossli and Thomas Rüppel

### v2.3.4 on 2013-02-25
* Hotfix: Add David Hossli as a new member of the managing board

### v2.3.3 on 2013-01-28
* Fix: rounding error exception in export when using big decimals

### v2.3.2 on 2013-01-28
* Fix: apply new immoscout accounts to config
* Fix: add address to office and include in external real estate export

### v2.3.1 on 2013-01-09
* Fix: update rails to 3.1.10 for params parsing vulnerability

### v2.3 on 2012-12-13
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
