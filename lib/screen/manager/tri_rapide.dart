import '../../models/Database_Model.dart';

class TriRapide {
  List<double> table;
  TriRapide({required this.table});

  // ----> Tri rapide :

  int partition(int G, int D) {
    // partition / Sedgewick /
    int i, j;
    double piv, temp;
    piv = table[D];
    i = G - 1;
    j = D;
    do {
      do i++; while (table[i] < piv);
      do j--; while (table[j] > piv);
      temp = table[i];
      table[i] = table[j];
      table[j] = temp;
    } while (j > i);
    table[j] = table[i];
    table[i] = table[D];
    table[D] = temp;
    return i;
  }

  List<double> QSort(int G, int D) {
    // tri rapide, sous-programme récursif
    int i;
    if (D > G) {
      i = partition(G, D);
      QSort(G, i - 1);
      QSort(i + 1, D);
    }

    return table;
  }

  List<double> tableauTrie(List<double> table) {
    int i, j, k;
    var n = table.length;
    for (i = 0; i < n; i++) {
      for (j = i + 1; j < n;) {
        if (table[j] == table[i]) {
          table.removeAt(j);
          n--;
        } else
          j++;
      }
    }
    return table;
  }
}

class TriRapidejson {
  List<Map<String, dynamic>> table;
  UserModel deliver = new UserModel(name: 'fabiol',idDoc: "audrey");

  TriRapidejson({required this.table});

  // ----> Tri rapide :

  int partition(int G, int D) {
    // partition / Sedgewick /
    int i, j;
    double piv;
    Map<String, dynamic> temp = {'Deliver': deliver, 'Distance': 0};
    piv = table[D]['Distance'];
    i = G - 1;
    j = D + 1;

    for (int j = G; j < D; j++) {
      if (table[j]['Distance'] <= piv) {
        i++;
        temp = {
          'Deliver': table[i]['Deliver'],
          'Distance': table[i]['Distance']
        };
        table[i] = {
          'Deliver': table[j]['Deliver'],
          'Distance': table[j]['Distance']
        };

        table[j] = {'Deliver': temp['Deliver'], 'Distance': temp['Distance']};
      }
    }
    /* do {
      do i++; while (table[i]['Distance'] < piv);
      do j--; while (table[j]['Distance'] > piv);
      temp = {'Deliver': table[i]['Deliver'], 'Distance': table[i]['Distance']};
      table[i] = {
        'Deliver': table[j]['Deliver'],
        'Distance': table[j]['Distance']
      };

      table[j] = {'Deliver': temp['Deliver'], 'Distance': temp['Distance']};
    } while (j > i); */

    temp = {
      'Deliver': table[i + 1]['Deliver'],
      'Distance': table[i + 1]['Distance']
    };
    table[i + 1] = {
      'Deliver': table[D]['Deliver'],
      'Distance': table[D]['Distance']
    };
    table[D] = {'Deliver': temp['Deliver'], 'Distance': temp['Distance']};

/* 
    table[j]['Distance'] = table[i]['Distance'];
    table[j]['Deliver'] = table[i]['Deliver']; 
    table[i]['Distance'] = table[D]['Distance'];
    table[i]['Deliver'] = table[D]['Deliver'];
    table[D]['Distance'] = temp['Distance'];
    table[D]['Deliver'] = temp['Deliver'];*/

    return i + 1;
  }

  List<Map<String, dynamic>> QSort(int G, int D) {
    // tri rapide, sous-programme récursif
    int i;
    if (D > G) {
      i = partition(G, D);
      QSort(G, i - 1);
      QSort(i + 1, D);
    }

    return table;
  }
}
