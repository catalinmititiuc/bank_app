# bank_app

## Hootsuite Backend Internship

Tehnologiile folosite pentru dezvoltarea aplicatiei sunt:
	* Python 2.7.12
	* Flask 0.12.1
	* pymongo 3.4.3
	* Jinja2 2.9.6
	* Docker 17.04.0-ce
	* docker-compose 1.11.2
	* HTML, CSS, JS

Flask este un framework de python pentru crearea de aplicatii web. Are definite cate o ruta pentru fiecare entry point al aplicatiei:
	* route('/'): metoda asociata main_page() care cauta in baza de date primele 50 de inserari si dupa ce face conversia timestamp-ului din secunde intr-o data ce poate fi inteleasa de forma hh:mm DD/MM/YYYY afiseaza aceste inserari, afisarea poate fi controlata Show/Hide prin apasarea butonului "Show/Hide All Transactions"
	* route('/drop_db/'): metoda asociata drop_db() care face drop la baza de date prin apasarea butonului rosu "Drop DB"
	* route('/transactions/'): metoda asociata transactions() corespunde cu  POST-ul in care se poate:
		* primi un JSON, daca am primit in headers application/json, se transforma timestamp-ul in UNIX time si se face testarea ca senderul sa nu mai fi facut o tranzactie la acelasi timestamp, am presupus ca un sender nu poate face 2 tranzactii simultan la acelasi moment de timp, daca nu a mai facut atunci se adauga informatia in baza de date
		* citim datele din form, caz in care se vor produce aceiasi pasi
	* route('/transactions/'): metoda asociata transactions2() corespunde cu GET-ul in care se cere lista de tranzactii a unui user intr-o anumita zi si peste un anumit prag, se face interogarea bazei de date cand userul este sender si respectiv receiver, suma sa fie mai mare decat pragul stabilit, formatul zile este DD/MM/YYYY, care va fi transformat in UNIX time si toate timestamp-urile care se incadreaza intre 00:00 si 23:59 a zile respective vor face match
	* route('/balance/'): metoda asociata balance() in care timpii since si until sunt de forma DD/MM/YYYY si vor fi transformati in UNIX time, voi calcula balance-ul cu (+) atunci cand userul este receiver si (-) cand este sender, timestamp-urile trebuie sa fie cuprinse intre since ora 00:00 si until ora 23:59