import 'package:filament_nexus/features/wiki/domain/wiki.dart';

final List<Wiki> mockWikiEntries = [
  Wiki(
    id: 'stringing',
    title: 'Stringing',
    description:
    'Stringing bedeutet, dass während des Drucks dünne Fäden von geschmolzenem Filament zwischen den Teilen eines Modells entstehen. Es tritt auf, wenn die Düse von einem Bereich zu einem anderen bewegt wird und dabei kleine Mengen Filament austreten, die dann als feine Fäden zurückbleiben.',
  ),

  Wiki(
    id: 'warping',
    title: 'Warping',
    description:
    'Warping ist ein häufiges Problem beim 3D-Druck, bei dem sich die Ecken oder Kanten eines gedruckten Objekts während des Abkühlens verziehen oder anheben. Dies geschieht, wenn die Schichten des gedruckten Objekts ungleichmässig abkühlen und sich zusammenziehen, was zu Spannungen im Material führt. Warping kann dazu führen, dass das Objekt nicht mehr flach auf der Druckplatte liegt und die Druckqualität beeinträchtigt wird.',
  ),

  Wiki(
    id: 'shrinking',
    title: 'Shrinking',
    description:
    'Shrinking, auch als Schrumpfen bezeichnet, ist ein Phänomen beim 3D-Druck, bei dem das gedruckte Objekt während des Abkühlens an Grösse verliert. Dies geschieht, weil die Materialien, insbesondere thermoplastische Filamente, beim Erhitzen und Schmelzen expandieren und beim Abkühlen wieder zusammenziehen. Wenn das Objekt nicht gleichmässig abkühlt oder wenn die Druckeinstellungen nicht optimal sind, kann dies zu ungleichmässigem Schrumpfen führen, was die Passgenauigkeit und die Gesamtqualität des gedruckten Objekts beeinträchtigen kann.',
  ),
];