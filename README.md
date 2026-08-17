# Transferarbeit - Filament Nexus App

Dieses Readme wird dazu verwendet, um die Transferarbeit zu dokumentieren. Es enthält Informationen über die Aufgabenstellung, die Vorgehensweise und die Ergebnisse der Arbeit.
Nach erfolgreicher Beurteilung der Arbeit, wird dieses Readme neu geschrieben um die App zu dokumentieren. Es wird dann als Dokumentation der App dienen und die wichtigsten Informationen über die App enthalten.

## App-Idee

Die App wird anhand des im letzten Semester erstellten Prototyps entwickelt. Es handelt sich hierbei um eine App, mit welcher 3D-Druck Filamente und ihre Eigenschaften katalogisiert und verwaltet werden können.
Die App soll es ermöglichen, Informationen über verschiedene Filamene festzuhalten und zur Verfügung zu stellen. Zusätzlich soll die App Funktionen zur Suche und Filterung der Filamente bieten.

## Startseite mit Flutter (Grundgerüst)

Die App startet auf der Übersicht mit allen Filamenten. Sie ist ein Stateful Widget, da sich die Liste der Filamente ändern kann, wenn neue hinzugefügt, bestehende bearbeitet oder filter gesetzt werden.
Es gibt auch einen FloatingActionButton, um ein neues Filament hinzuzufügen.

#### AppBar

In der AppBar ist der Titel "Filament Nexus", der Icon-Button für das Profil, die Suche und die beiden Filter für Material und Eigenschaften.

#### Body

Im Body ist eine Liste als Stateful Widget implementiert, die die Filamente anzeigt. Jedes Filament ist auf dieser Seite ein Stateful Widget.
Die Liste ist eine Column, die die Filamente in Form von Cards anzeigt. Die Cards sind untereinander angeordnet.

#### FloatingActionButton

Der FloatingActionButton führt zu einem neuen Bildschirm, auf dem ein neues Filament hinzugefügt werden kann. Dieser Bildschirm ist ebenfalls ein Stateful Widget, da die Eingabefelder für die Filamentinformationen aktualisiert werden können.

#### Footer

Der Footer enthält die Navigation zwischen der Übersichtsseite (Startseite) und der Seite für die eigenen Filamente. Er ist ein Stateful Widget, da sich die Auswahl der Seite ändern kann.

## Erste Struktur der "Home" Seite

Die Home-Seite ist die Seite "Alle Filamente" und hat folgende Aufbau:

```
Alle Filamente - Stateful Widget
└───Scaffold
        └───AppBar
        |       └─── Titel
        |       └─── Avatar
        └─── Body
        |       └─── Padding
        |               └─── FilamentCardsList - Stateful Widget
        |                       └─── Column
        |                               └─── FilamentCard - Stateful Widget
        |                                       └─── Container
        |                                               Row
        |                                               └─── Column
        |                                               |        └─── Icon (Filament)
        |                                               └─── Column
        |                                                       └─── Text (Typ)
        |                                                       └─── Text (Material)
        |                                                       └─── Row
        |                                                       |        └─── Icon (NozzleTemp)
        |                                                       |        └─── Text (NozzleTemp)
        |                                                       |        └─── Icon (BedTemp)
        |                                                       |        └─── Text (BedTemp)
        |                                                       └─── Row
        |                                                       |        └─── Icon (PrintSpeed)
        |                                                       |        └─── Text (PrintSpeed)
        |                                                       |        └─── Icon (FanSpeed)
        |                                                       |        └─── Text (FanSpeed)
        |                                                       └─── Icon (Pfeil)
        |
        └─── BottomNavigationBar
        |       └─── NavigationDestination (Alle Filamente)
        |       └─── NavigationDestination (Meine Filamente)
        └─── FloatingActionButton
                └───Icon (add)
```

## App-Struktur

Grundsätzlich verwenden wir für diese App die Feature-Struktur. Folgende Struktur inkl. Files ist geplant:

```
lib
├───app
│   ├───theme
│   app.dart
├───features
│   ├───filaments
|   |   ├───data
|   |   |   └───filament_repository.dart
|   |   ├───domain
|   |   |   └───filament.dart
|   |   └───presentation
|   |         ├───all_filaments_screen.dart
|   |         ├───my_filaments_screen.dart
|   |         ├───filament_details_screen.dart
|   |         ├───add_edit_filament_screen.dart
|   |         └───widgets
|   |              └───filament_list.dart
│   ├───profile
|   |   ├───data
|   |   ├───domain
|   |   └───presentation
|   |         └───profile_screen.dart
├───shared
|   └───widgets
├───main.dart
```

## Aufbau der App und Widgets(beschrieben)

Die Filament Nexus App wird in der `main.dart` gestartet und ruft dort einzig das Widget `FilamentNexus` auf, welche in der `app.dart` erstellt ist.  
In der `app.dart` wird das MaterialApp Widget erstellt, welches die grundlegende Struktur der App definiert. Es enthält das AppTheme und die Startseite (home) mit dem Widget `HomeSehll`. Die `HomeShell` ist ein Stateful Widget, welches die Navigation zwischen den verschiedenen Seiten der App ermöglicht (BottomNavigation) und die AppBar definiert.
In der AppBar befindet sich der Titel der aktuellen Seite, sowie das Icon für das Profil. Zusätzlich ist der `FloatingActionButton` definiert, der das Hinzufügen von neuen Filamenten ermöglicht.

Die `HomeShell` ist somit das zentrale Grundgerüst für alle Seiten der App.

Für die Seiten "Alle Filamente" und "Meine Filamente" werden jeweils eigene Stateful Widgets erstellt, welche die jeweiligen Inhalte anzeigen. Die Seite "Alle Filamente" zeigt eine Liste aller Filamente an, während die Seite "Meine Filamente" nur die vom Nutzer hinzugefügten Filamente anzeigt.  
Die Filamente sind in Form von Cards dargestellt, welche die wichtigsten Informationen über das Filament anzeigen. Jede Card ist ein eigenes Stateless Widget, welches die Informationen über das Filament als Parameter erhält. Wird von `Alle Filamente` auf ein Filament gedrückt, so wird ein Modal geöffnet mit einer Detailansicht des Filaments.
Von `Meine Filamente` aus, wird die Bearbeitungsseite des Filaments geöffnet.

Im Drawer (Burgermenü oben links) der App befindet sich eine Infoseite, eine Wiki-Seite und eine Über uns Seite. Sie werden in `app.dart` über eigene Funktionen aufgerufen und bestehen aus eigenen Scaffolds, welche eigene AppBars und Bodies haben.

## Abweichungen zur Aufgabenstellung der Transferarbeit

- Das Profil ist nicht wie gefordert teil der BottomNavigation, sondern als Icon in der AppBar.
- Gemäss Aufgabe darf eine ListTile oder eigene Zeile verwendet werden. Wir haben die Liste der Filamente so gelöst, dass ein `ListenableBuilder` verwendet wird. Darin enthalten sidn dann die Listen mit einer `ListView` anstelle der `ListTile`. Es werden somit keine `ListTile` verwendet, sondern eigene Zeilen in Form von `Cards`.
- Der Detailscreen ist als Modal gelöst, anstatt als eigener Screen. Es wird somit kein eigener Screen für die Detailansicht erstellt, sondern ein Modal, welches als `Dialig` geöffnet wird. Es wird damit nicht mit `Navigator.push` gearbeitet, sondern mit `showDialog`.
- Der Infobereich ist nicht in der BottomNaviation, sondern in einem Drawer umgesetzt, weil aus unserer Sicht die Informationen über die App nicht so wichtig sind, dass sie in der BottomNavigation einen eigenen Platz verdienen.

# Abgabe Teil 2

## Welche Daten werde in Firebase gespeichert?
- Userdaten in der integrierten Firebase Authentifizierung. Nicht als implementiertes eigenes Schema.
- Filamente mit den Eigenschaften gemäss: [lib\features\filaments\domain\filament.dart](https://github.com/SyntaxWizardBB/filament_nexus/blob/main/lib/features/filaments/domain/filament.dart)

## Wo sind die CRUD operationen umgesetzt?
CURD operationen sind hier umgesetzt: [lib\features\filaments\data\firebase_filament_data_source.dart](https://github.com/SyntaxWizardBB/filament_nexus/blob/main/lib/features/filaments/data/firebase_filament_data_source.dart)

## Was wurde gegenüber Teil 1 weiterentwickelt?
- Die App ist nun mit Firebase verbunden und kann Daten speichern und abrufen.
- Es gibt eine Benutzerregistrierung und Anmeldung über Firebase Authentifizierung.
- Die App ist nun in der Lage, die Filamente eines Benutzers zu speichern und anzuzeigen. (CRUD-Operationen)
- Der Benutzer hat ein Benutzerprofil, welches er bearbeiten kann. (Benutzername, Passwort)

## Was wäre eine sinnvolle nächste Erweiterung für Teil 3?
- Andere Registrationsmöglichkeiten wie Google, Facebook, Apple, etc. implementieren.
- Mehr Inhalt für das Wiki erstellen, damit die App mehr Informationen über Filamente bietet.
- Wiki erweitern mit Bilder
- PDF Anhänge für Filamente (z.B. Datenblätter) implementieren.
- Zusätzliche Filtermöglichkeiten für die Filamente implementieren, z.B. nach Hersteller, Max. Drucktemperatur (Aktuell Hersteller als Zusatzfilter mit der Suche möglich)