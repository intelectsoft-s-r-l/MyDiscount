import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 242, 241, 1),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 8),
        child: Container(
          padding:
              const EdgeInsets.only(top: 11, bottom: 11, left: 8, right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Text('Politica de confidențialitate\n\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 18
                      )),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: '   •	Informații generale\n\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text:'   Confidențialitatea datelor dumneavoastră cu caracter personal reprezintă una dintre preocupările principale ale companiei IntelectSoft Srl în calitate de operator de date, cu sediul pe str. Alba Iulia 154 et.3, Chișinău, MD- 2064, Republica Moldova. Acest document are rolul de a vă informa cu privire la prelucrarea datelor dumneavoastră cu caracter personal, în contextul utilizării aplicației My Discount. (în continuare Aplicație)\n',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: '\n   •	Utilizarea și Colectarea datelor \n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '\n   •	Date furnizate prin interacțiuni directe\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '''\n   Când vă înregistrați pentru utilizarea Aplicației noastre, este posibil să colectăm următoarele informații despre dumneavoastră:
   •	dacă vă înregistrați folosind contul Google: prenume, nume și adresa de email;
   •	dacă vă înregistrați utilizând contul de Facebook: colectăm prenumele și numele așa cum apar în contul dumneavoastră de Facebook și Numărul de Identificare Facebook. În cazul în care ați acordat Facebook permisiunea prin opțiunea de confidențialitate din cadrul aplicației (care apare chiar înainte să vă înregistrați pe Aplicația noastră), este posibil să colectăm sexul, vârsta sau adresa dumneavoastră de email, în funcție de permisiunile date de dumneavoastră.
   •	În vederea asigurării funcţionalitaţii Aplicaţiei, vom prelucra datele referitoare la dispozitivul utilizat (hardware) şi sistemul de operare, informaţii de jurnal, precum adresa IP, data şi ora utilizării Aplicaţiei. 
	 •	Prin intermediul Aplicaţiei nu vor fi colectate şi divulgate date privind originea rasială sau etnică, convingerile politice, religioase, filozofice sau de natură similară, de apartenenţă sindicală sau date cu caracter personal privind starea de sănătate sau viaţa sexuală.
   •	Informaţiile confidenţiale preluate de pe Aplicație sunt folosite numai în sensul utilizării cu succes a serviciilor oferite, dar şi pentru a lua legătura cu Dumneavoastră în caz de necesitate. În plus, vor putea fi folosite pentru a vă prezenta noi oportunităţi, oferte sau alte informaţii.
''',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: '\n    •	Utilizarea aplicației\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              '\n   Te rugăm să furnizezi numai date şi informaţii reale şi, în mod special, să nu furnizezi date de identificare care nu îţi aparţin (spre exemplu să nu foloseşti o adresă de email falsă sau care aparţine unei alte persoane). Pe cale de consecinţă, IntelectSoft îşi rezervă dreptul de a verifica veridicitatea datelor şi informaţiilor furnizate de tine în procedura creării contului de utilizator, precum şi dreptul de a refuza deschiderea unui cont de utilizator dacă informaţiile furnizate sunt nereale sau, după caz, de a suspenda sau închide un astfel de cont. Totodata, în calitate de utilizator înţelegi şi accepţi că eşti exclusiv şi deplin responsabil pentru informaţiile furnizate în procedura creării contului de utilizator.',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text:
                              '\n\n    •	Actulizarea informațiilor incluse în această politică\n\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              '    IntelectSoft poate actualiza periodic prezenta Politică, pe măsură ce activitatea şi serviciile prestate de aceasta se extind sau se schimbă, sau în situaţia în care IntelectSoft este obligată potrivit legii să aducă modificări. În cazul în care IntelectSoft face acest lucru, va afişa cea mai actuală versiune in Aplicatie. Prin urmare, te rugăm să verifici periodic dacă există actualizări. În cazul în care IntelectSoft aduce modificări majore practicilor specificate în prezenta Politică, te vom notifica utilizând datele de contact disponibile.',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: '\n\n    Informații juridice\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '''Adresa office: or.Chisinau, str. Alba Iulia 154 et.3
Adresa juridică: MD-2051,Republica Moldova, mun. Chisinau, str. Alba-Iulia, nr. 200, ap. 105.
Telefon:  (+373) 22 835 312

''',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: '\n    Contacte\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              '''   Pentru orice informații cu privire la aplicația My Discount, vă rugăm să apelați la nr. (+373) 22 835 312''',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: '\n\n    Informații generale\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'MyDiscount este o aplicație mobilă pe care o puteți instala gratuit atât pentru telefoanele care utilizeaza sistemul de operare Android, accesând Magazinul Google Play, cât și pe telefoanele cu iOS accesând App Store.\n',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
