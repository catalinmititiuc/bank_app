# bank_app

## Hootsuite Backend Internship

#### Tehnologiile folosite pentru dezvoltarea aplicatiei sunt:
  - Python 2.7.12
  - Flask 0.12.1
  - pymongo 3.4.3
  - Jinja2 2.9.6
  - Docker 17.04.0-ce
  - docker-compose 1.11.2
  - HTML, CSS, JS

Flask este un framework de python pentru crearea de aplicatii web. Are definita cate o ruta pentru fiecare entry point al aplicatiei:

* route('/'): 
metoda asociata main_page() care cauta in baza de date primele 50 de inserari si dupa ce face conversia timestamp-ului din secunde intr-o data ce poate fi inteleasa de forma ```hh:mm DD/MM/YYYY``` afiseaza aceste inserari, afisarea poate fi controlata Show/Hide prin apasarea butonului ```"Show/Hide All Transactions"``` din josul paginii

* route('/drop_db/'):
metoda asociata drop_db() care face drop la baza de date prin apasarea butonului rosu ```"Drop DB"```

* route('/transactions/'):
metoda asociata transactions() corespunde cu  POST-ul in care se poate:
    * primi un ```JSON```, daca am primit in headers ```application/json```, se transforma timestamp-ul in ```UNIX time``` si se face testarea ca sender-ul sa nu mai fi facut o tranzactie la acelasi timestamp, am presupus ca un sender nu poate face 2 tranzactii simultan la acelasi moment de timp, daca nu a mai facut atunci se adauga informatia in baza de date
	* citim datele din form, caz in care se vor produce aceiasi pasi

* route('/transactions/'):
metoda asociata transactions2() corespunde cu GET-ul in care se cere lista de tranzactii a unui user intr-o anumita zi si peste un anumit prag, se face interogarea bazei de date cand userul este sender si respectiv receiver, suma sa fie mai mare decat pragul stabilit, formatul zile este ```DD/MM/YYYY```, care va fi transformat in ```UNIX time``` si toate timestamp-urile care se incadreaza intre 00:00 si 23:59 a zile respective vor face match, ca rezultat se va incarca o pagina html transactions.html similara care in josul paginii va afisa un tabel cu toate intrarile din baza de date care au facut match, tabelul este generat dinamic prin jinja2 

* route('/balance/'):
metoda asociata balance() in care timpii ```since``` si ```until``` sunt de forma ```DD/MM/YYYY``` si vor fi transformati in UNIX time, voi calcula ```balance```-ul cu (+) atunci cand userul este receiver si (-) cand este sender, timestamp-urile trebuie sa fie cuprinse intre since ora 00:00 si until ora 23:59, ca rezultat se va incarca o noua pagina html balance.html care va avea un mesaj cu balance-ul calculat pentru perioada data

### Ierarhia de fisiere
* server_app
    * templates
        * index.html
        * transactions.html
        * balance.html
    * Dockerfile
    * app.py
    * docker-compose.yml
    * requirements.txt
* README.md
* run.sh
* test.sh

Fisierul app.py este cel in care se afla codul serverului.

Directorul templates cuprinde 3 pagini html:
* index.html - pagina principala
* transactions.html - pagina ce afiseaza lista tranzactiilor
* balance.html - pagina ce afiseaza balance-ul calculat

### Folosirea aplicatiei
1. Aplicatia poate fi folosita ruland scriptul ```run.sh```
2. Se poate accesa: ```http://127.0.0.1:5000```
3. Dupa accesarea link-ului se poate vedea o interfata cu cele 3 operatii ale API-ului:
* Add Transactions:
    forma input: sender: ```integer``` receiver:```integer``` timestamp:```hh:mm DD/MM/YYYY``` sum:```integer```
    ex. ```1``` ```2``` ```14:35 14/09/2016``` ```500```
Obs. Userii sunt integeri peste tot.
Daca campul timestamp este completat gresit sau este introdusa o data incorecta acel camp se va inrosi.

* List Transactions
    user:```integer``` day:```DD/MM/YYY``` threshold:```integer```
    ex. ```2``` ```12/01/2016``` ```300```

* Balance
    user:```integer``` since:```DD/MM/YYY``` until:```DD/MM/YYY```
    ex. ```3``` ```01/01/2016``` ```20/07/2016```

* Drop DB
    Acest buton va goli baza de date.

* Show/Hide All Transactions
    Acest buton va afisa/ascunde o lista cu 50 de tranzactii facute.

#### Informatii importante

Am ales sa folosesc pentru timestamp formatul ```hh:mm DD/MM/YYYY```, iar pentru day, since si until formatul ```DD/MM/YYYY```. Am considerat ca este mai usor de urmarit daca datele se vor citi asa, desi in spate le retin ca UNIX timestamps. In interfata cu utilizatorul fac teste ca datele sa fie valide si toate campurile unui form sa fie completate. Titlul ```Server API``` functioneaza ca un home button ca atunci cand se citeste transactions.html sau balance.html sa se revina la pagina initiala fara a modifica url-ul din browser.

### Bonus
Am folosit indexes pentru interogari, insa nu am reusit sa testez eficienta lor, ```.explain()['executionStats']``` nu intorcea campurile relevante.

Am un script de testare ```test.sh``` care incarca in baza de date 100 de tranzactii si face 3 GET-uri pentru lista de tranzactii si 3 GET-uri pentru balance. Scriptul va salva fisierele html in locatia scriptului.

***Formatul unui POST catre server:***

```curl -i -H "Content-Type: application/json" -X POST -d '{"sender":1, "receiver":2, "timestamp":"17:00 05/05/2016", "sum":700}' http://127.0.0.1:5000/transactions/ > /dev/null 2>&1```

***Formatul unui GET catre server:***
* **lista de tranzactii:**
```curl "http://127.0.0.1:5000/transactions/?user=7&day=05%2F05%2F2016&threshold=300" > transactions1.html```
* **balance**
```curl "http://127.0.0.1:5000/balance/?user=2&since=01%2F01%2F2016&until=20%2F12%2F2016" > balance1.html```

