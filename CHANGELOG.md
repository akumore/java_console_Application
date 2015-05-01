# CHANGELOG

### features/1165_scroll_to_floorplan
* New implemented User Stories:
  * #1165: Als Besucher möchte ich nach Klick auf “Grundriss anzeigen“ zum Grundriss gelangen

### v3.0.8 - 2015-04-20
* Fix exporter:
  * export real eastates correctly translated

### v3.0.7 - 2015-04-17
* Fix exporter:
  * Insert right translation for «Angebot»

### v3.0.6 - 2015-04-17
* Fix exporter:
  * Handle links in object description

* features/fix_undefined_method_year_for_nilclass
  * Avoiding the NoMethodError: undefined method 'year' for nil:NilClass when majestic12 bot is crawling

* features/add_forgotten_offer_html_to_cms_show_view
  * Add the forgotten offer_html field to figure show view in cms

### v3.0.5 - 2015-04-15
* Fix exporter:
  * Add title to offer_html
  * Do not remove opening ul tag after closing p tag
  * Update spec to match latest conditions

### v3.0.4 - 2015-04-02
* Fix handout:
  - fix handout caching (save file as Printout_[real_estate_title])
  - fix disappearance of 'Kontakt'
  - fix styles

### v3.0.3 - 2015-04-02
* Fix exporter:
  - fix export rake task
  - fix wrong single quotes
  - fix movement of built_on field from figure to information model

### v3.0.2 - 2015-04-01
* fix little writing mistake in DE home teaser ('Ihr' instead of 'ihr')
* translate main nav item 'Referenzen' in IT 'Referenze'

### v3.0.1 - 2015-03-30
* Hotfix: Allow cloning of real estates with reference number

### v3.0.0 - 2015-03-30
* Design changes on homepage
  * New tab navigation
  * Update link box in slider
  * New teasers
  * Full browser width footer with content update
  * Make Teasers same height in teaser brick
  * Use button-navigation on sliders
  * Fix filter in real estates for meduim

* New implemented User Stories:
  * #733 Als Besucher möchte ich ein grösseres P sehen
  * #4615 Als Besucher möchte ich keinen Slider im Header sehen
  * #4616 Als Besucher möchte ich die Unternavigation im Slider (Mieten und Kaufen) auf der Startseite kleiner sehen
  * #4623 Als Besucher möchte ich Teaser verwalten können und diese in einem Brick in der Website einfügen
  * #729: Als Besucher möchte ich den Bauen Tab sehen
  * #732: Als Besucher möchte ich 4 Teaser anstelle von 2 sehen
  * #734: Als Editor möchte ich die Seite «Angebot» und «Referenzen» im CMS pflegen können
  * #736: Als Besucher möchte ich die Tabs in einem einheitlichen Look sehen
  * #738: Als Editor möchte ich Meta Daten einer CMS Seite pflegen können
  * #740: Als Besucher möchte ich die neue Referenzobjekt-Navigation sehen
  * #752: Flat Design umsetzen
  * #769: Als Editor möchte ich News nicht publizieren können
  * #770: Als Besucher möchte ich die News nach Jahren sortiert sehen
  * #773: Als Besucher möchte ich für Immobilien einen Page Title und Description sehen können
  * #825: Als Benutzer möchte ich ein zentriertes Headerbild sehen

### v2.9.31 - 2015-03-26
* update job description text of David Hossli

### v2.9.30 - 2015-03-12
* Correct PLZ: 6568 -> 6528

### v2.9.29 - 2015-03-04
* Hotfix: Add Team Member

### v2.9.28 - 2015-02-12
* Hotfix: Fix Google Maps Bug in IE10

### v2.9.27
* Hotfix: Add «Entwicklung Schweiz» membership in footer

### v2.9.26
* Hotfix: Creater does not have to be present. (Allows save if creator was deleted)

### v2.9.25 - 2015-01-05
* Add 50th anniversary button

### v2.9.24 on 2014-12-10
* Allow ul tags for homegate

### v2.9.23 on 2014-11-27
* Update real estate api for microsite with documents

### v2.9.22 on 2014-10-30
* Hotfix: Update ftp uploader to avoid disconnects because of timeouts
* New implemented User Stories:
  * #4476: Invalidate cached handouts when contact content changes

### v2.9.21 on 2014-10-03
* Hotfix: Add ability to add image to existing download brick

### v2.9.20 on 2014-10-02
* Hotfix: Add SAA Certificate image on jobs page

### v2.9.19 on 2014-09-03
* Hotfix: Update text for Forum slide (vision slider)

### v2.9.18 on 2014-09-02
* Hotfix: Reorder slider (image movie is now the first slider and forum the last one)

### v2.9.17 on 2014-08-28
* Hotfix: Replace «Umbau» image within accordion on company page

### v2.9.16 on 2014-08-22
* Display retargeting pixel on all pages

### v2.9.15 on 2014-07-23
* New implemented User Stories:
  * Fix: Login into backend is not possible anymore because of a problem in new helper method which renders retargeting pixel

### v2.9.14 on 2014-07-22
* New implemented User Stories:
  * Fix: #4143 - Als Besucher möchte ich auf den externen Portalen, die Beschreibung der Immobilien korrekt formatiert sehen
  * #4189 Als Entwickler möchte ich das Retargeting Pixel versteckt im HTML einbinden

### v2.9.13 on 2014-07-21
* New implemented User Stories:
  * #4143 - Als Besucher möchte ich auf den externen Portalen, die Beschreibung der Immobilien korrekt formatiert sehen

### v2.9.12 on 2014-07-17
* Update special_sauce gem to have pracitcally mongoid sync rake tasks avaliable

### v2.9.11 on 2014-06-11
* New implemented User Stories:
  * #3810 - Als Editor möchte ich ein Flag setzen können, welches das Anmeldeformular anzeigt oder nicht
* Hotfix:
  * Add show_application_form boolean to cms show view

### v2.9.10 on 2014-05-22
* Track news item documents
* Update document title for exported real estate documentation

### v2.9.9 on 2014-05-21
* Add translated subtitle in generated handout for sale real estates
* Add rb-readline gem

### v2.9.8 on 2014-05-20
* Enable enable handout generation also for sale real estates

### v2.9.7 on 2014-05-16
* Add event tracking information for Forum PDF download in vision slider and downlaod brick

### v2.9.6 on 2014-04-30
* Directly link forum slide to current PDF

### v2.9.5 on 2014-04-22
* Bug Fix:
  * Fix slider image for the new forum magazine (correct size to 1000x500 px)

### v2.9.4 on 2014-04-22
* New implemented User Stories:
  * #2810 - Als Besucher möchte ich den Teaser zum neuen Forum im Vision Slider sehen
  * #3417 - Als Immobilienplatform möchte ich das korrekte unload.txt File erhalten

* Other improvements:
  * Upddate blazing to prevent crontab overwrites
  * Add spam protection for contact mailer, appointment, handout order and job application forms

### v2.9.3 on 2014-04-10

* Increase server timeout to 300

### v2.9.2 on 2014-04-10

* Hotfix Real Estate copy
* Do not user tls on local email delivery

### v2.9.1 on 2014-04-09

* Reenabled cronjobs

### v2.9.0 on 2014-04-07

* Hosting Migration auf c3

### v2.8.9 on 2014-04-03
* New implemented User Stories:
  * #3297 - Als Besucher möchte ich keine leeren Seiten in der Objektdokumentation sehen
  * #3327 - Als Besucher möchte ich alle Grundrisse in der Objektdokumentation sehen
  * #3356 - Als Besucher möchte ich bei Immobilien unter Arbeiten die Nutzfläche unter Immobilieninfos bei der entsprechenden Immobilie sehen

### v2.8.8 on 2014-03-31
* Hotfix
  * Remove David Spiess from company leaders

### v2.8.7 on 2014-03-26
* New implemented User Stories:
  * #3228 - Als Microsite möchte ich das "Etwa verfügbar ab" Bezugsdatum sehen
  * #3229 - Als Microsite möchte ich "Dienstleisungsfläche" als Gruppenindikator erhalten
  * #3238 - Als Besucher möchte ich die Zimmeranzahl nicht sehen, wenn sie 0 ist

* Other improvements:
  * Added page break after floorplan in handout PDF to avoid blang pages
  * Default sort field within storing utilization is now «usable_surface» not «rooms» (frontend)
  * The text attribute of a job is not required anymore to pass validations (CMS)
  * Add a checkbox to remove uploaded job profile file (CMS)
  * Update job profile drop down menu to show only published and localized job profiles (frontend)
  * Add aclado as a new exporter (export)

### v2.8.6 on 2014-01-22
* Bug Fixes:
 * #2806 - Hotfix - Als Editor möchte ich auch eine invalide Immobilie wieder bearbeiten können

### v2.8.5 on 2014-01-20
New implemented User Stories:

* Feature 'Archivierung':
  * #2709 - Als Editor möchte ich Immobilien archivieren können
  * #2710 - Als Editor möchte ich archivierte Immobilien wieder editieren können
  * #2711 - Als Editor möchte ich eine bessere Performance in der Immobilienübericht haben
* Feature 24
  * #2595 - Als Editor möchte ich das Bezugsdatum im Tab "Preise/Bezug" eingeben können

### v2.8.4 on 2014-01-15
* New implemented User Stories:
  * #2781 - Als Besucher möchte ich alle Vision-Slider Slides übersetzt sehen
  * #2787 - Als Besucher möchte ich die korrekte PLZ der Filiale Camorino sehen

* Coding improvements:
  * track floor plan printing in gallery (google analytics)

### v2.8.3 on 2014-01-10
* Feedback Stories
  * #2642 - Als Editor möchte ich ein zugeschnittenes Bild in der Vorschau genau so sehen, wie es im Frontend auch angezeigt wird.
  * #2643 - Als Editor möchte die Option 'im Verhältnis 2:1' nur bei der Bearbeitung von Grundrissen sehen
  * #2644 - Als Editor möchte ich beim Aktualisieren eines Bildes/Grundrisses im Bearbeitungsformular bleiben und nicht in die Medienübersicht gelangen
  * #2645 - Als Editor möchte ich im WYSIWYG Editor eingeschränkte Möglichkeiten der Formatierung haben
  * #2647 - Als Editor möchte ich, dass beim Zuschneiden der Bilder die Option 'im Verhältnis 2:1' korrekt funktioniert

* Feature 20 - Komforterweiterungen im Eingabetool für Editoren
  * #1720 - Als Editor möchte ich bei Angebotsbildern den Bildausschnitt und die Zoomstufe auswählen können
  * #1872 - Als Entwickler möchte ich bestehende Markdown Text in HTML umgewandelt haben
  * #1873 - Als Entwickler möchte ich den CKEditor integrieren
  * #1874 - Als Entwickler möchte ich die Markdownspezifischen Methoden im Exporter aufgeräumt haben
  * #1925 - Als Editor möchte ich die Checkbox für das Ratio hübsch gestyled haben

* Bug Fixes:
  * #2765 - Als Besucher möchte ich die ergänzenden Informationen unter dem Immobilieninfos Tab korrekt ausgerichtet sehen

### v2.8.2 on 2013-12-19
* New implemented User Stories:
  * #2720 - Verwaltungsrats Titel entfernen

### v2.8.1 on 2013-12-13
* Hotfix: Enable event tracking for static documents (media assets)

### v2.8.0 on 2013-11-28
New implemented stories:

* Feedback Stories
  * #2470 - Als Editor möchte ich die Hausnummern in der Immobilienübersicht und im Dashboard nicht doppelt sehen
  * #2472 - Als Editor möchte ich in der Immobilienübersicht nach dem Titel suchen/filtern können
  * #2471 - Als Besucher möchte ich im 'Objektdokumentation bestellen' Formular die Firma optional eingeben können, auch wenn es sich um 'Wohnen' handelt
  * #2473 - Als Editor möchte ich beim Erfassen einer Immobilie entweder 'Objektdokumentation' oder 'Objektdokumentation bestellen' auswählen können
  * #2599 - Als Besucher möchte ich die Preiseinheit einer Immobilie immer in der Kurz-Info sehen

* Feature 16 - Kleinere Optimierung von Darstellungen und Texten im Eingabetool und auf der Website
  * #1405 - Als Editor möchte ich andere Namen für die vorhandenen Ausgabekanäle sehen
  * #1403 - Als Besucher und Leser möchte ich das "N" beim eingestellten Winkel sehen

* Feature 18 - Verbesserte Immobilienlisten im Eingabetool
  * #1587 - Als Editor möchte ich die Immobilienliste im Eingabetool sortieren können
  * #1711 - Als Editor möchte ich die Ausgabekanäle durch Icons markiert angezeigt bekommen
  * #1712 - Als Editor möchte ich Immobiliendetails in der Übersichtsliste angezeigt bekommen
  * #1713 - Als Editor möchte ich bei den bearbeiteten und zuletzt publizierten Immobilien den Ort und die Adresse anstelle des Titels sehen

* Feature 19 - Eingabe und Darstellung der Objekt-Arten
  * #1715 - Als Editor möchte ich die Objektarten in den Gruppen Wohnen, Arbeiten, Lagern, Parkieren gruppiert
  * #1716 - Als Editor möchte ich die Objektarten priorisiert alphabetisch sortiert auswählen können
  * #1717 - Als Editor möchte ich in der Immobilie nur Objektarten auswählen können, die der ausgewählten Gebäudenutzung zugeordnet sind
  * #1718 - Als Editor möchte ich Nutzungsarten im Feld "Alle möglichen Objekt-Arten" eingeben
  * #1719 - Als Besucher möchte ich eine kombinierte Ansicht von Objekt-Art und allen möglichen Objekt-Arten einer Immobilie sehen

### v2.7.4 on 2013-10-31
* Add data attributes for project develpment link on homepage to track event

### v2.7.3 on 2013-10-31
* Enable reference projects in main nav for the last time (on live system)

### v2.7.2 on 2013-10-29
* Disable reference projects in main nav again (on live system)

### v2.7.1 on 2013-10-25
* Update microsite API:
  * show 'Nutzfläche' and 'Geschoss' in 'Immobilieninfos' of disponibles

* Bug Fix:
  * show figure fields in figure show view based on real_estate utilization

### v2.7.0 on 2013-10-23
* New implemented stories:
  * #1044 - Als Besucher möchte ich einheitlich formatierte Preise und Zahlen in einem definierten Format
  * #1045 - Als Besucher möchte ich Preise rechtsbündig ausgerichtet ansehen können
  * #1047 - Als Editor möchte ich neue Preiseinheiten für Mieten und Kaufen auswählen können
  * #1048 - Als Editor möchte ich zusätzlich den monatlichen Preis für alle Preise angeben können, wenn die Preiseinheit m2/Jahr eingestellt ist
  * #1049 - Als Editor möchte ich die Nebenkosten auch für Kaufobjekte ausweisen können (aber nur bei Mieten Pflichtfeld)
  * #1050 - Als Editor möchte ich sämtliche monatlichen Nebenkosten automatisiert anhand der jährlichen Kosten berechnen
  * #1051 - Als Besucher möchte ich anstelle des Labels "Mietpreis" die Objekt-Art sehen, z.B. Wohnung
  * #1052 - Als Besucher und Leser möchte ich die zusätzlichen monatlichen Preise sehen, wenn die Preiseinheit m2/Jahr eingestellt ist
  * #1053 - Als Besucher möchte ich die Nebenkosten für Kaufobjekte sehen
  * #1054 - Als Besucher möchte ich sehen, wenn die Preise ohne MwSt. angeben sind
  * #1055 - Als Besucher und Leser möchte ich Preise und Nebenkosten für Lager sehen können
  * #1056 - Als Besucher und Leser möchte ich für Parkplätze immer nur den monatlichen Preis sehen, wenn der jährliche und der monatliche Preis verfügbar sind
  * #1058 - Als Editor möchte ich die Informationen zu Mietzinsdepot und Mietinformationen nicht länger eingeben müssen (gilt für alle Gebäudenutzungen!)
  * #1091 - Als Editor möchte ich bestimmen, ob ein Angebot über Kabelfernsehen verfügt
  * #1092 - Als Editor möchte ich bestimmen, ob ein Angebot im Bereich Arbeiten/Lagern über Toiletten verfügt
  * #1094 - Als Editor sollen bestimmte Gebäudeinformationen nur auf Dritt-Websites dargestellt werden
  * #1095 - Als Editor möchte ich erweiterte Angaben zum Ausbau eingeben
  * #1098 - Als Besucher und Leser möchte ich die Raumhöhe sehen können
  * #1099 - Als Besucher und Leser möchte ich Angaben zur Bodenbelastung angezeigt bekommen in xxxkg/m2
  * #1100 - Als Editor möchte ich zusätzlich die Information «Warenlift» bei einer Immobilie eingeben können
  * #1101 - Als Besucher und Leser möchte ich sehen, wenn eine Gewerbeimmobilie einen Warenlift hat
  * #1111 - Als Leser möchte ich überarbeitete Titel und Labels für die übersetzten Texte in der Objektdokumentation sehen
  * #1354 - Als Exporter möchte ich die Beschreibungstexte mit dem richtigen Inhalt auf immostreet.ch exportieren
  * #1399 - Als Editor möchte ich das Bestellen der gedruckten Objektdokumentation für ein Angebot ermöglichen
  * #1400 - Als Immobilienbewirtschafter möchte ich Anfragen für Objektdokumentationen erhalten
  * #1401 - Als Besucher möchte ich eine gedruckte Objektdokumentation bestellen können
  * #1494 - Als Editor möchte ich beim Erfassen einer Immobilie auswählen können, welche Microsite (Gartenstadt, Feldpark, Bünzpark) hinterlegt ist
  * #1495 - Als Entwickler möchte ich ein spezifisches JSON anhand eines Parameters pro Microsite generieren können
  * #1959 - Als Editor möchte ich eine Validation auf der Referenznummer
  * #1960 - Als Besucher und Leser möchte ich die Preise richtig ausgerichtet sehen
  * #1961 - Als Besucher möchte ich den aktuellen Vision-Slider sehen
  * #1981 - Als Besucher und Leser möchte ich beim Preis sehen, ob die Nebenkosten inklusive sind, oder nicht
  * #1982 - Als Besucher und Leser möchte ich das Bezug ab Feld richtig formatiert sehen
  * #1983 - Als Besucher und Leser möchte ich die richtigen Übersetzungen sehen
  * #1984 - Als Besucher und Leser möchte ich das Feld «Aussicht» sehen
  * #2221 - Als Editor möchte ich die Checkboxen im Info Tab möglichst zusammengefasst sehen
  * #2347 - Als Besucher möchte ich Rivista ohne Per la vorangestellt sehen
  * #2413 - Als Administrator möchte ich Objektdokumentation bestellen auch bei Wohnen anklicken können.
  * #2447 - Als Besucher möchte ich beim Bestellen einer Objektdoku eines 'Wohnen' Objekts keine Firma eintragen müssen

* Also implemented:
  * Enable reference projects in main navigation

### v2.6.5 on 2013-10-17
* Move class for application-form-link to RealEstateDecorator to hide the application forms (on detail page and appointment form) for the Bünzpark and Feldpark real estate.

### v2.6.4 on 2013-10-03
* Microsite API update:
  * Sort building key numerically if the key is/includes a number

### v2.6.3 on 2013-09-26
* New implemented stories:
  * 2192 - Als Entwickler möchte ich die Immobilien über die Microsite API korrekt gruppiert erhalten

### v2.6.2 on 2013-09-05
* New implemented stories:
  * #2011 - Als Entwickler möchte ich in den Microsite JSONs Bezug unter dem Punkt Preise/Bezug sehen
  * #2070 - Als Entwickler möchte ich die real estates der Microsites nach Gruppe, Building Key, Stockwerk und Wohnfläche sortiert haben
  * #2071 - Als Entwickler möchte ich die Gruppen Labels in neuem Format sehen
  * #2041 - Als Editor möchte ich bei einer Immobilie Gartensitzplatz als Info zuweisen

### v2.6.1 on 2013-09-04
* New implemented stories:
  * #2068 - Als Besucher möchte ich das Anmeldeformular bei der Felpark Immobilie nicht mehr sehen

### v2.6.0 on 2013-08-16
* New implemented stories:
  * #1953 - Als Besucher möchte ich das maximale Gewicht für den Warenlift in «kg» sehen

### v2.5.9 on 2013-08-12
* Additional Fixes
  * Add id of real estate to the detail div in show view
  * Hide application form for Bünzpark real estate

### v2.5.8 on 2013-08-12
* Additional Fixes
  * Update Tracking ID because of new universal analytics (analytics.js)

### v2.5.7 on 2013-08-08
* Additional Fixes
  * Outsource GA category translator in lib directory => Keep DRY
  * Always use German translations for GA category translations

### v2.5.6 on 2013-08-07
* New implemented stories:
  * #1737 - Als Entwickler möchte ich den aktuellen Google Analytics Code integrieren
  * #1738 - Als Entwickler möchte ich einen separaten Google Analytics Code für Staging integrieren
  * #1739 - Als Entwickler möchte ich die Event Tracking Codes für das Betrachten einer Immobilie integrieren
  * #1740 - Als Entwickler möchte ich die Event Tracking Codes für die Detailansicht einer Imobilie integrieren
  * #1741 - Als Entwickler möchte ich die Event Tracking Codes für die Unternehmensseite integrieren
  * #1742 - Als Entwickler möchte ich die Event Tracking Codes für die Jobsseite integrieren
  * #1780 - Als Entwickler möchte ich die Event Tracking Codes für diverse SublimeVideos integrieren

### v2.5.5 on 2013-08-07
* New implemented stories (Bugfix):
  * 1864 Als Besucher möchte ich in der Einzelübersicht von Immobilien beim Feld 'Maximales Gewicht für Warenlift' pro m2 sehen
  * 1865 Als Besucher möchte ich in der Einzelübersicht von Immobilien die Felder 'Lagerpreis' und 'Lagernebenkosten' in der durch den Editor eingestellten Preiseinheit dargestellt sehen

* Additional Fixes
  * Hotfix for Feldpark microsite (Application form link if storage utilization)
  * Add missing translations for generic utilization translation
  * Update airbrake gem
  * Set rubygems source to https
  * Update readme with deployment instructions

### v2.5.4 on 2013-07-31
* New implemented stories (Bugfix):
  * 1852 Als Editor möchte ich, dass Parkplätze nach dem Export mit dem korrekten Titel angezeigt werden

### v2.5.3 on 2013-07-30
* New implemented stories (Bugfix):
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
