# Architektur-Entscheide

Dokumentiert die bewussten Abweichungen vom Kursbeispiel (Task-App) und deren
Begründung für Filament Nexus.

---

## 1. Firestore-Struktur: flache Collection statt `users/{userId}/…`

**Kursbeispiel:** `users/{userId}/tasks/{taskId}`
**Filament Nexus:** `filaments/{filamentId}` mit einem Feld `userId`

**Begründung:**
Die Task-App ist rein privat — jeder sieht nur seine eigenen Tasks. Filament
Nexus hat dagegen **zwei Sichten auf denselben Datenbestand**:

| Bereich | Zweck |
|---|---|
| **Alle Filamente** | gemeinsamer Katalog — alle Nutzer sehen alle Filamente inkl. fremder Bewertungen |
| **Meine Filamente** | nur die selbst erfassten Einträge (bearbeit-/löschbar) |

Mit `users/{userId}/filaments/{id}` läge jedes Filament im privaten Unterbaum
seines Erstellers. Ein Nutzer könnte fremde Filamente technisch nicht lesen —
der **Katalog als Kernfeature der App wäre nicht umsetzbar**.

Die flache Collection mit `userId`-Feld erfüllt beides:
* **Lesen** für alle Angemeldeten → „Alle Filamente"
* **Schreiben/Löschen** nur durch den Eigentümer → über die Rules erzwungen
* „Meine Filamente" filtert clientseitig auf `userId == uid`

Die geforderte Zugriffstrennung passiert also nicht über den *Pfad*, sondern
über die *Security Rules* — mit demselben Schutzniveau, aber passend zur
Fachlichkeit.

## 2. Ladezustand über `ChangeNotifier` statt `FutureBuilder`

**Kursbeispiel:** `FutureBuilder` direkt im Listen-Screen
**Filament Nexus:** `FilamentRepository extends ChangeNotifier` mit
`isLoading` / `loadError`, die Screens hängen per `ListenableBuilder` daran.

**Begründung:**
Die Daten werden an **zwei Stellen gleichzeitig** gebraucht („Alle" und
„Meine"), und Create/Update/Delete müssen beide Listen sofort aktualisieren.
Ein `FutureBuilder` pro Screen würde zweimal laden und nach jeder Änderung
auseinanderlaufen. Das Repository ist die **eine Datenquelle**; der
Ladezustand wird identisch dargestellt (`CircularProgressIndicator` während des
Ladens, Meldung bei leerer Liste oder Fehler).

## 3. Datenquelle umschaltbar (lokal ↔ Firestore)

`AppConfig.useFirebase` wählt zwischen `LocalFilamentDataSource` (Mock-Daten)
und `FirebaseFilamentDataSource` (Firestore). Beide erfüllen dasselbe Interface
`FilamentDataSource`, kein Screen kennt den Unterschied.

**Nutzen:** Die App bleibt ohne Netz/Firebase lauffähig (Demo, Tests), und der
Backend-Wechsel berührt keine UI-Datei.

## 4. Document-ID

Beim Anlegen wird die ID **von Firestore vergeben**: `add()` liefert
`docRef.id`, der als `Filament.id` ins Objekt zurückfließt. Beim Bearbeiten
adressiert genau diese ID über `update()` das richtige Document; `delete()`
nutzt sie ebenso. Die lokale Datenquelle verhält sich gleich (vergibt beim
Anlegen selbst eine ID), damit beide Modi identisch funktionieren.

## 5. Authentifizierung: E-Mail/Passwort statt anonym

Statt des anonymen Logins ist direkt die **Challenge-Variante** umgesetzt:
Registrierung und Login mit E-Mail/Passwort, `authStateChanges()` entscheidet
per `StreamBuilder` zwischen `AuthScreen` und App.

**Begründung:** Filamente und Bewertungen sind personenbezogene, dauerhafte
Daten — ein anonymer Account ginge beim Neuinstallieren verloren. Zusätzlich
ersetzt Firebase Auth das zuvor selbstgebaute SHA-256-Passwort-Hashing, das
für echte Anmeldedaten nicht ausreichend sicher ist.
