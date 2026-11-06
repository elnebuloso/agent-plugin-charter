# Ganzheitliche UX-Analyse und Entwicklung eines UI-Zielbildes

## 1. Zielsetzung

Analysiere die bestehende Webapplication ganzheitlich aus der Perspektive eines erfahrenen UX-Designers und Product Designers.

Ziel ist es, ein umfassendes Konzeptdokument zu erstellen, das beschreibt, wie sich die Benutzeroberfläche und die Benutzerführung der Anwendung zukünftig entwickeln sollen.

Dabei geht es ausdrücklich **nicht primär um eine optische Überarbeitung oder ein neues visuelles Design**.

Der Fokus liegt auf:

- Usability und Benutzerfreundlichkeit
- Verständlichkeit der Anwendung
- Intuitiver Benutzerführung
- Sinnvoller Informationsarchitektur
- Logischer Seiten- und Funktionsstruktur
- Konsistenz zwischen verschiedenen Bereichen
- Skalierbarkeit der Anwendung
- Einer nachhaltigen und wiederverwendbaren Komponentenarchitektur

Das Ergebnis soll eine klare konzeptionelle Grundlage für die anschließende Umsetzung einer verbesserten UI sein.

## 2. Bestandsaufnahme der bestehenden Anwendung

Verschaffe dir zunächst einen vollständigen Überblick über die bestehende Anwendung.

Erstelle Screenshots von allen erreichbaren Seiten und relevanten Ansichten.

Der Screenshot-Prozess soll nicht nur die initialen Seitenzustände erfassen, sondern auch relevante Interaktionszustände berücksichtigen.

Dazu gehören beispielsweise:

- Geöffnete Dialoge und Modals
- Dropdown-Menüs
- Aufgeklappte Navigationselemente
- Formulare und deren Zustände
- Tabellen und Detailansichten
- Filter- und Suchfunktionen
- Erfolgs- und Fehlermeldungen
- Leere Zustände (Empty States)
- Ladezustände
- Unterschiedliche Ansichten abhängig von Benutzerrollen

Übergib die Screenshots einem spezialisierten Subagenten mit dem Fokus auf UX und Usability.

Der Subagent darf und soll die Anwendung bei Bedarf selbstständig bedienen und durch die verschiedenen Bereiche navigieren, um Zusammenhänge und Interaktionen besser zu verstehen.

Die Analyse darf sich nicht ausschließlich auf Screenshots stützen. Die tatsächliche Bedienung der Anwendung ist ausdrücklich erwünscht.

Dokumentiere zunächst die bestehende Seitenstruktur und die vorhandenen Funktionen, bevor du Änderungen oder Verbesserungsvorschläge ableitest.

## 3. UX- und Usability-Analyse

Untersuche die Anwendung systematisch.

Beantworte insbesondere folgende Fragen:

- Ist die Anwendung intuitiv verständlich?
- Finden Nutzer die benötigten Funktionen ohne unnötige Umwege?
- Ist die Navigation logisch aufgebaut?
- Sind Seiten und Funktionen sinnvoll gruppiert?
- Sind Bezeichnungen und Beschreibungen verständlich?
- Gibt es unnötige Komplexität?
- Sind ähnliche Funktionen an unterschiedlichen Stellen unterschiedlich umgesetzt?
- Gibt es redundante Informationen oder Funktionalitäten?
- Sind wichtige Aktionen und deren Konsequenzen ausreichend verständlich?
- Gibt es Sackgassen in der Benutzerführung?
- Ist die Hierarchie zwischen wichtigen und weniger wichtigen Informationen nachvollziehbar?
- Funktioniert die Anwendung auch bei einer wachsenden Anzahl an Funktionen und Seiten?

Betrachte dabei nicht nur einzelne Seiten, sondern insbesondere die gesamte Benutzerführung und die Zusammenhänge zwischen den verschiedenen Bereichen.

Identifiziere konkrete Probleme und leite nachvollziehbare Verbesserungsvorschläge ab.

## 4. Zwei klar getrennte UI-Bereiche

Die zukünftige Anwendung soll konzeptionell auf zwei unterschiedlichen Layouts basieren.

### 4.1 Nicht-Management-Bereich

Dieser Bereich umfasst alle regulären Anwendungsbereiche außerhalb der administrativen Verwaltung.

Dazu gehören beispielsweise:

- Startseite
- Reguläre Anwendungsseiten
- Funktions- und Inhaltsseiten
- Hilfeseiten
- Informationsseiten
- Weitere Bereiche für normale Anwender

Entwickle hierfür ein eigenständiges, zur Nutzung passendes Layout.

Berücksichtige insbesondere eine möglichst einfache und verständliche Bedienung sowie eine klare Nutzerführung.

Die Benutzer sollen sich auf ihre eigentlichen Aufgaben konzentrieren können, ohne durch administrative Funktionen oder unnötige Komplexität abgelenkt zu werden.

### 4.2 Management-Bereich

Der Management-Bereich soll als eigenständiger Admin- beziehungsweise Management-Bereich konzipiert werden.

Die grundsätzliche Vorstellung ist ein modernes Admin-Dashboard mit einer dauerhaft nachvollziehbaren Navigationsstruktur.

Als mögliche Elemente kommen beispielsweise infrage:

- Sidebar / Side Navigation
- Übergeordnete Navigationsgruppen
- Dashboard- beziehungsweise Übersichtsseiten
- Einheitliche Seitenlayouts
- Wiederverwendbare Verwaltungsansichten
- Tabellen- und Listenansichten
- Detail- und Bearbeitungsansichten
- Einheitliche Filter- und Suchmechanismen

Die konkrete Struktur soll anhand der tatsächlich vorhandenen Funktionen entwickelt werden.

Wichtig ist, dass dieser Bereich langfristig wachsen kann.

Neue Management-Funktionen sollen sich später sinnvoll integrieren lassen, ohne dass die gesamte Navigation oder das Layout grundlegend neu aufgebaut werden muss.

Die bestehenden Management-Funktionen müssen vollständig und sinnvoll in das neue Konzept integriert werden.

## 5. Seitenstruktur und Informationsarchitektur

Entwickle eine nachvollziehbare Zielstruktur für die gesamte Anwendung.

Dokumentiere:

- Welche Seiten und Bereiche existieren?
- Welche Seiten gehören zusammen?
- Welche Seiten sollten zusammengeführt werden?
- Welche Bereiche sollten voneinander getrennt werden?
- Welche Navigationshierarchie ist sinnvoll?
- Welche Seiten sind eigenständige Seiten?
- Welche Inhalte gehören in Tabs, Dialoge oder Unterseiten?
- Welche neuen Seiten oder Ansichten werden benötigt?
- Welche bestehenden Seiten können entfallen?

Erstelle eine vollständige Ziel-Sitemap.

Die Sitemap soll die logische Struktur und den Umfang der zukünftigen Anwendung zeigen.

Beschreibe außerdem die wichtigsten Nutzerwege zwischen den Seiten und Funktionen.

## 6. Komponentenarchitektur

Analysiere die vorhandenen UI-Komponenten und entwickle daraus eine nachhaltige Komponentenstrategie.

Dabei gelten folgende Grundsätze:

- Neue Komponenten dürfen recherchiert und eingeführt werden.
- Bestehende Komponenten dürfen angepasst werden.
- Gleichartige Komponenten sollen nach Möglichkeit vereinheitlicht und zusammengeführt werden.
- Unnötige oder redundante Komponenten dürfen entfernt werden.
- Fehlende Komponenten sollen identifiziert werden.
- Komponenten sollen möglichst wiederverwendbar und unabhängig von einzelnen Seiten aufgebaut sein.

Berücksichtige dabei ausdrücklich die bestehende Storybook-Struktur.

Storybook soll als zentrale Dokumentations- und Entwicklungsgrundlage für die wiederverwendbaren UI-Komponenten dienen.

Definiere nach Möglichkeit sinnvolle Komponentenbereiche und Kategorien, beispielsweise:

- Layout Components
- Navigation Components
- Form Components
- Data Display Components
- Feedback Components
- Overlay Components
- Management Components

Vermeide unnötige Sonderlösungen und seitenindividuelle Komponenten, wenn eine gemeinsame Lösung sinnvoller ist.

Die Komponentenarchitektur soll sowohl den regulären Anwendungsbereich als auch den Management-Bereich unterstützen.

## 7. Anforderungen an das Zieldokument

Erstelle ein ausführliches und strukturiertes Konzeptdokument, das als verbindliche Grundlage für die zukünftige UI-Entwicklung dienen kann.

Das Dokument soll insbesondere folgende Inhalte umfassen:

1. Zusammenfassung der Analyse
2. Übersicht der bestehenden Anwendungsstruktur
3. Identifizierte Usability-Probleme
4. Empfohlene Verbesserungen
5. Zukünftige Informationsarchitektur
6. Vollständige Ziel-Sitemap
7. Konzept für den Nicht-Management-Bereich
8. Konzept für den Management-Bereich
9. Beschreibung der zukünftigen Seiten- und Layouttypen
10. Navigation und Nutzerführung
11. Komponentenstrategie
12. Storybook-Struktur und Komponentenorganisation
13. Umgang mit bestehenden Komponenten
14. Fehlende oder neu benötigte Komponenten
15. Empfehlungen für die schrittweise Umsetzung
16. Priorisierung der Maßnahmen

### Besonders wichtig: Beschreibung der Seiten und Ansichten

Beschreibe möglichst ausführlich, welche Seiten, Unterseiten und Ansichten die zukünftige Anwendung umfassen soll.

Dabei soll die konzeptionelle Struktur beschrieben werden und nicht die konkrete Position einzelner Bedienelemente.

**Nicht erwünscht:**

"Oben links befindet sich der Logout-Button."

**Erwünscht:**

"Die Seite dient der Verwaltung der Benutzerkonten und ermöglicht das Anlegen, Bearbeiten, Deaktivieren und Löschen von Benutzern. Die zugehörigen Aktionen und Informationen sollen in einer konsistenten Verwaltungsansicht zusammengefasst werden."

Beschreibe also den Zweck einer Seite, ihre Aufgaben, die zugehörigen Funktionen, ihre Beziehungen zu anderen Seiten und ihre Rolle innerhalb der Anwendung.

Das Dokument soll ein konzeptionelles Zielbild liefern und keine bloße Beschreibung der aktuellen Oberfläche sein.

## 8. Priorisierung und Umsetzung

Bewerte die identifizierten Änderungen hinsichtlich:

- UX-Auswirkung
- Benutzerrelevanz
- Technischer Komplexität
- Abhängigkeiten zu anderen Änderungen
- Bedeutung für die zukünftige Skalierbarkeit

Unterscheide zwischen:

- Kritischen Verbesserungen
- Wichtigen strukturellen Verbesserungen
- Sinnvollen Optimierungen
- Optionalen Erweiterungen

Erstelle daraus eine sinnvolle Reihenfolge für die spätere Umsetzung.

Berücksichtige dabei, dass bestehende Funktionen erhalten bleiben müssen, sofern nicht ausdrücklich eine begründete Änderung oder Entfernung vorgeschlagen wird.

## 9. Erwartetes Ergebnis

Das finale Ergebnis soll ein möglichst vollständiges, nachvollziehbares und umsetzbares UX- und UI-Konzept sein.

Es soll einem Entwicklerteam ermöglichen, die zukünftige Struktur der Anwendung zu verstehen und darauf aufbauend die UI systematisch weiterzuentwickeln.

Das Dokument soll nicht nur beschreiben, was aktuell verbessert werden könnte, sondern vor allem festlegen:

- Wie die Anwendung zukünftig strukturiert sein soll.
- Welche Seiten und Bereiche benötigt werden.
- Wie die Benutzer zwischen diesen Bereichen navigieren.
- Welche Aufgaben die einzelnen Seiten erfüllen.
- Wie sich der Management-Bereich langfristig erweitern lässt.
- Wie eine konsistente Komponentenarchitektur aufgebaut wird.
- Welche Rolle Storybook dabei spielt.

**Arbeite gründlich, hinterfrage bestehende Strukturen kritisch und entwickle ein konsistentes Gesamtkonzept. Übernimm bestehende Lösungen nicht ungeprüft, nur weil sie bereits implementiert sind. Gleichzeitig dürfen keine bestehenden Funktionen versehentlich verloren gehen.**

Phase 1
UX-Audit und Bestandsaufnahme

- Screenshots aller Seiten und Zustände
- Analyse der Navigation
- Identifikation von Usability-Problemen
- Bestandsaufnahme der Funktionen und Komponenten
  
  Phase 2
  UX-Zielbild und Architektur
- Neue Informationsarchitektur
- Zwei eigenständige Layoutkonzepte
- Ziel-Sitemap
- Seiten- und Funktionskonzept
- Komponenten- und Storybook-Strategie
  
  Phase 3
  Umsetzungsleitfaden
- Priorisierte Maßnahmen
- Abhängigkeiten
- Migrationsstrategie
- Schrittweise Umsetzung
- Abnahmekriterien

## Verbindlicher Arbeitsablauf

Arbeite strikt in den drei definierten Phasen:

1. **Phase 1 – UX-Audit und Bestandsaufnahme:** Untersuche die vollständige Anwendung und dokumentiere den Ist-Zustand.
2. **Phase 2 – UX-Zielbild und Architektur:** Entwickle auf Basis der Analyse das vollständige zukünftige UI- und UX-Konzept.
3. **Phase 3 – Umsetzungsleitfaden:** Erstelle einen konkreten, priorisierten Plan für die spätere Implementierung.

Wichtig:

- Führe zunächst ausschließlich Analysen und Dokumentationen durch.
- Verändere keine bestehenden Dateien, Komponenten oder Funktionen.
- Beginne nicht mit der Implementierung.
- Überspringe keine Phase.
- Erfinde keine Funktionen oder Anforderungen, die nicht durch die Analyse begründet sind.
- Kennzeichne Annahmen und offene Fragen ausdrücklich.
- Prüfe die Vollständigkeit der Analyse, bevor du zur nächsten Phase übergehst.

Das finale Ergebnis muss als eigenständiges, ausführliches Dokument vorliegen, das als verbindliche Grundlage für einen späteren Implementierungsauftrag verwendet werden kann (auf deutsch, da ich das nur lesen möchte mit dir).