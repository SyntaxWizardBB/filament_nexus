import 'package:filament_nexus/features/wiki/domain/wiki.dart';

final List<Wiki> mockWikiEntries = [
  Wiki(
    id: 'stringing',
    title: 'Stringing',
    description:
    'Stringing bedeutet, dass während des Drucks dünne Fäden von geschmolzenem Filament zwischen den Teilen eines Modells entstehen. Es tritt auf, wenn die Düse von einem Bereich zu einem anderen bewegt wird und dabei kleine Mengen Filament austreten, die dann als feine Fäden zurückbleiben.',
    imagePath: 'assets/wiki/stringing.png',
  ),

  Wiki(
    id: 'warping',
    title: 'Warping',
    description:
    'Warping ist ein häufiges Problem beim 3D-Druck, bei dem sich die Ecken oder Kanten eines gedruckten Objekts während des Abkühlens verziehen oder anheben. Dies geschieht, wenn die Schichten des gedruckten Objekts ungleichmässig abkühlen und sich zusammenziehen, was zu Spannungen im Material führt. Warping kann dazu führen, dass das Objekt nicht mehr flach auf der Druckplatte liegt und die Druckqualität beeinträchtigt wird.',
    imagePath: 'assets/wiki/warping.png',
  ),

  Wiki(
    id: 'shrinking',
    title: 'Shrinking',
    description:
    'Shrinking, auch als Schrumpfen bezeichnet, ist ein Phänomen beim 3D-Druck, bei dem das gedruckte Objekt während des Abkühlens an Grösse verliert. Dies geschieht, weil die Materialien, insbesondere thermoplastische Filamente, beim Erhitzen und Schmelzen expandieren und beim Abkühlen wieder zusammenziehen. Wenn das Objekt nicht gleichmässig abkühlt oder wenn die Druckeinstellungen nicht optimal sind, kann dies zu ungleichmässigem Schrumpfen führen, was die Passgenauigkeit und die Gesamtqualität des gedruckten Objekts beeinträchtigen kann.',
    imagePath: 'assets/wiki/shrinking.png',
  ),

  Wiki(
    id: 'elephant_foot',
    title: 'Elefantenfuss',
    description:
    'Der Elefantenfuss (Elephant Foot) beschreibt ein Ausbeulen der untersten Schichten eines Modells, wodurch die Basis breiter wird als der Rest des Objekts. Er entsteht, wenn das Gewicht der darüberliegenden Schichten auf noch nicht vollständig abgekühltes Material drückt, häufig verstärkt durch eine zu hohe Temperatur der Druckplatte oder eine zu niedrig eingestellte erste Schicht. Gegenmassnahmen sind eine tiefere Betttemperatur, eine korrekte Kalibrierung des Z-Abstands, ausreichende Bauteilkühlung sowie eine kleine Fase (Chamfer) an der Modellunterseite oder die Slicer-Funktion "Elephant Foot Compensation".',
    imagePath: 'assets/wiki/elephant_foot.png',
  ),

  Wiki(
    id: 'layer_shifting',
    title: 'Schichtversatz',
    description:
    'Beim Schichtversatz (Layer Shifting) sind einzelne Schichten gegenüber den darunterliegenden horizontal verschoben, sodass das Modell stufig oder schief wirkt. Ursache ist meist, dass der Druckkopf die vom Slicer vorgegebene Position verliert: zu hohe Druck- oder Beschleunigungswerte, lose Zahnriemen, verschmutzte oder lockere Riemenscheiben, ein streifender Druckkopf oder Schrittmotortreiber, die zu heiss werden. Abhilfe schaffen geringere Geschwindigkeiten, das Nachspannen und Prüfen der Riemen und Schrauben, das Festziehen der Grubschrauben an den Riemenscheiben sowie eine bessere Kühlung der Elektronik.',
    imagePath: 'assets/wiki/layer_shifting.png',
  ),

  Wiki(
    id: 'ghosting',
    title: 'Ghosting',
    description:
    'Ghosting (auch Ringing oder Echoing) zeigt sich als wellenförmige Wiederholung von Kanten und Ecken auf der Oberfläche, kurz nachdem der Druckkopf eine scharfe Richtungsänderung gemacht hat. Es handelt sich um Vibrationen, die durch die Massenträgheit des bewegten Druckkopfs entstehen und sich in den Druck übertragen. Reduzieren lässt sich Ghosting durch niedrigere Druckgeschwindigkeit und Beschleunigung, einen steiferen und gut verschraubten Rahmen, das korrekte Spannen der Riemen sowie durch Resonanzkompensation wie Input Shaping.',
    imagePath: 'assets/wiki/ghosting.png',
  ),
];
