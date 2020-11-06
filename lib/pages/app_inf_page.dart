
import 'package:MyDiscount/widgets/widgets/top_bar_image.dart';
import 'package:MyDiscount/widgets/widgets/top_bar_text.dart';
import 'package:flutter/material.dart';

class AppInfoPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              TopBarImage(size: size),
              AppBarText(size: size, text: 'App Info'),
              Positioned(
                top: size.height * .06,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            height: size.height * .8,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text('''
              Politica de confidențialitate
1. Informații generale
Confidențialitatea datelor dumneavoastră cu caracter personal reprezintă una dintre preocupările principale ale companiei IntelectSoft Srl în calitate de operator de date, cu sediul pe str. Alba Iulia 154 et.3, Chișinău, MD- 2064, Republica Moldova. Acest document are rolul de a vă informa cu privire la prelucrarea datelor dumneavoastră cu caracter personal, în contextul utilizării aplicației My Discount. (în continuare Aplicație).

2. Utilizarea și Colectarea datelor
2.1. Date furnizate prin interacțiuni directe
Când vă înregistrați pentru utilizarea Aplicației noastre, este posibil să colectăm următoarele informații despre dumneavoastră:

dacă vă înregistrați folosind contul Google: prenume, nume și adresa de email;
dacă vă înregistrați utilizând contul de Facebook: colectăm prenumele și numele așa cum apar în contul dumneavoastră de Facebook și Numărul de Identificare Facebook. În cazul în care ați acordat Facebook permisiunea prin opțiunea de confidențialitate din cadrul aplicației (care apare chiar înainte să vă înregistrați pe Aplicația noastră), este posibil să colectăm sexul, vârsta sau adresa dumneavoastră de email, în funcție de permisiunile date de dumneavoastră.;
2.2. În vederea asigurării funcţionalitaţii Aplicaţiei, vom prelucra datele referitoare la dispozitivul utilizat (hardware) şi sistemul de operare, informaţii de jurnal, precum adresa IP, data şi ora utilizării Aplicaţiei.
2.2. În vederea asigurării funcţionalitaţii Aplicaţiei, vom prelucra datele referitoare la dispozitivul utilizat (hardware) şi sistemul de operare, informaţii de jurnal, precum adresa IP, data şi ora utilizării Aplicaţiei.
2.4. Informaţiile confidenţiale preluate de pe Aplicație sunt folosite numai în sensul utilizării cu succes a serviciilor oferite, dar şi pentru a lua legătura cu Dumneavoastră în caz de necesitate. În plus, vor putea fi folosite pentru a vă prezenta noi oportunităţi, oferte sau alte informaţii.
3. Utilizarea aplicației
Te rugăm să furnizezi numai date şi informaţii reale şi, în mod special, să nu furnizezi date de identificare care nu îţi aparţin (spre exemplu să nu foloseşti o adresă de email falsă sau care aparţine unei alte persoane). Pe cale de consecinţă, IntelectSoft îşi rezervă dreptul de a verifica veridicitatea datelor şi informaţiilor furnizate de tine în procedura creării contului de utilizator, precum şi dreptul de a refuza deschiderea unui cont de utilizator dacă informaţiile furnizate sunt nereale sau, după caz, de a suspenda sau închide un astfel de cont. Totodata, în calitate de utilizator înţelegi şi accepţi că eşti exclusiv şi deplin responsabil pentru informaţiile furnizate în procedura creării contului de utilizator.

4. Actulizarea informațiilor incluse în această politică
IntelectSoft poate actualiza periodic prezenta Politică, pe măsură ce activitatea şi serviciile prestate de aceasta se extind sau se schimbă, sau în situaţia în care IntelectSoft este obligată potrivit legii să aducă modificări. În cazul în care IntelectSoft face acest lucru, va afişa cea mai actuală versiune in Aplicatie. Prin urmare, te rugăm să verifici periodic dacă există actualizări. În cazul în care IntelectSoft aduce modificări majore practicilor specificate în prezenta Politică, te vom notifica utilizând datele de contact disponibile.

Informații juridice
Adresa: MD-2051, Republica Moldova,str. Alba Iulia 154 et.3
Telefon: (+373) 22 835 312

Informații generale
MyDiscount este o aplicație mobilă pe care o puteți instala gratuit atât pentru telefoanele care utilizeaza sistemul de operare Android, accesând Magazinul Google Play, cât și pe telefoanele cu iOS accesând App Store.
              '''),
            ),
          ),
        ],
      ),
    );
  }
}
