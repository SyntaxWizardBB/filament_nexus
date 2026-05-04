# Transferarbeit - Filament Nexus App

Dieses Readme wird dazu verwendet, um die Transferarbeit zu dokumentieren. Es enthält Informationen über die Aufgabenstellung, die Vorgehensweise und die Ergebnisse der Arbeit.

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