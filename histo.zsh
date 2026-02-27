Modélisation de bases de données/projet/mariages
❯ ll
total 70068
-rw-rw-r-- 1 dawson@kali dawson@kali   621605 19 févr.  2024 mariages_L3_5k.csv
-rw-rw-r-- 1 dawson@kali dawson@kali 71120984 19 févr.  2024 mariages_L3.csv


Modélisation de bases de données/projet/mariages
❯ cut -d"," -f14 mariages_L3_5k.csv | sort | uniq > departement.csv


Modélisation de bases de données/projet/mariages
❯ cut -d"," -f2 mariages_L3_5k.csv | sort | uniq > type_acte.csv


Modélisation de bases de données/projet/mariages
❯ cut -d"," -f13,14 mariages_L3_5k.csv | sort | uniq > commune.csv


Modélisation de bases de données/projet/mariages
❯ nano extraction.awk


Modélisation de bases de données/projet/mariages took 15min
❯ awk -f extraction.awk mariages_L3_5k.csv


Modélisation de bases de données/projet took 8s
cat << 'EOF' > creation_tables.sql
-- 1. Table Departement
CREATE TABLE Departement (
    code_departement VARCHAR(2) PRIMARY KEY CHECK (code_departement IN ('44', '49', '79', '85'))
);

-- 2. Table Commune
CREATE TABLE Commune (
    nom_commune VARCHAR(255) PRIMARY KEY,
    code_departement VARCHAR(2) REFERENCES Departement(code_departement)
);

-- 3. Table Type_Acte
CREATE TABLE Type_Acte (
    libelle VARCHAR(100) PRIMARY KEY
);

-- 4. Table Personne
CREATE TABLE Personne (
    id_personne INT PRIMARY KEY,
    nom VARCHAR(255),
    prenom VARCHAR(255),
    id_pere INT REFERENCES Personne(id_personne),
    id_mere INT REFERENCES Personne(id_personne)
);

-- 5. Table Acte
CREATE TABLE Acte (
    id_acte VARCHAR(50) PRIMARY KEY,
    date_acte VARCHAR(50),
    num_vue VARCHAR(50),
    type_acte VARCHAR(100) REFERENCES Type_Acte(libelle),
    nom_commune VARCHAR(255) REFERENCES Commune(nom_commune),
    code_departement VARCHAR(2) REFERENCES Departement(code_departement),
    id_personne_A INT REFERENCES Personne(id_personne),
    id_personne_B INT REFERENCES Personne(id_personne)
);
EOF


S5/Modélisation de bases de données/projet
❯ sudo -u postgres psql -d projet_genealogie -f creation_tables.sql


Modélisation de bases de données/projet/mariages
❯ cat << 'EOF' > insertion_donnees.sql
-- 1. Insertion des Départements
\copy Departement (code_departement) FROM './departement.csv' DELIMITER ',' CSV;

-- 2. Insertion des Communes
\copy Commune (nom_commune, code_departement) FROM './commune.csv' DELIMITER ',' CSV;

-- 3. Insertion des Types d'actes
\copy Type_Acte (libelle) FROM './type_acte.csv' DELIMITER ',' CSV;

-- 4. Insertion des Personnes
\copy Personne (id_personne, nom, prenom, id_pere, id_mere) FROM './table_personne.csv' DELIMITER ',' NULL 'NULL';

-- 5. Insertion des Actes
\copy Acte (id_acte, date_acte, num_vue, type_acte, nom_commune, code_departement, id_personne_A, id_personne_B) FROM './table_acte.csv' DELIMITER ',' CSV NULL 'NULL';
EOF


Modélisation de bases de données/projet/mariages
❯ sudo -u postgres psql -d projet_genealogie -f insertion_donnees.sql
COPY 4
COPY 375
COPY 7
COPY 12395
COPY 5000


Modélisation de bases de données/projet/mariages
❯ cat << 'EOF' > requetes.sql
\echo '========================================================'
\echo '       RÉSULTATS DES QUESTIONS DES GÉNÉALOGISTES        '
\echo '========================================================'
\echo ''

\echo '--------------------------------------------------------'
\echo ' QUESTION 1 : La quantité de communes par département'
\echo '--------------------------------------------------------'
SELECT code_departement, COUNT(*) AS nombre_de_communes
FROM Commune
GROUP BY code_departement
ORDER BY nombre_de_communes DESC;

\echo '--------------------------------------------------------'
\echo ' QUESTION 2 : La quantité d actes à LUÇON'
\echo '--------------------------------------------------------'
SELECT COUNT(*) AS quantite_actes_lucon
FROM Acte
WHERE nom_commune = 'LUÇON';

\echo '--------------------------------------------------------'
\echo ' QUESTION 3 : La quantité de "contrats de mariage" avant 1855'
\echo '--------------------------------------------------------'
SELECT COUNT(*) AS contrats_avant_1855
FROM Acte
WHERE type_acte = 'Contrat de mariage'
AND date_acte != 'n/a'
AND TO_DATE(date_acte, 'DD/MM/YYYY') < '1855-01-01';

\echo '--------------------------------------------------------'
\echo ' QUESTION 4 : La commune avec la plus grande quantité de "publications de mariage"'
\echo '--------------------------------------------------------'
SELECT nom_commune, COUNT(*) AS nb_publications
FROM Acte
WHERE type_acte = 'Publication de mariage'
GROUP BY nom_commune
ORDER BY nb_publications DESC
LIMIT 1;

\echo '--------------------------------------------------------'
\echo ' QUESTION 5 : La date du premier acte et le dernier acte'
\echo '--------------------------------------------------------'
SELECT MIN(TO_DATE(date_acte, 'DD/MM/YYYY')) AS date_premier_acte,
       MAX(TO_DATE(date_acte, 'DD/MM/YYYY')) AS date_dernier_acte
FROM Acte
WHERE date_acte ~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$';

\echo '========================================================'
\echo '                  FIN DES REQUÊTES                      '
\echo '========================================================'
EOF


Modélisation de bases de données/projet/mariages
❯ sudo -u postgres psql -d projet_genealogie -f requetes.sql
========================================================
       RÉSULTATS DES QUESTIONS DES GÉNÉALOGISTES
========================================================

--------------------------------------------------------
 QUESTION 1 : La quantité de communes par département
--------------------------------------------------------
 code_departement | nombre_de_communes
------------------+--------------------
 85               |                313
 79               |                 51
 44               |                  9
 49               |                  2
(4 lignes)

--------------------------------------------------------
 QUESTION 2 : La quantité d actes à LUÇON
--------------------------------------------------------
 quantite_actes_lucon
----------------------
                  105
(1 ligne)

--------------------------------------------------------
 QUESTION 3 : La quantité de "contrats de mariage" avant 1855
--------------------------------------------------------
 contrats_avant_1855
---------------------
                 196
(1 ligne)

--------------------------------------------------------
 QUESTION 4 : La commune avec la plus grande quantité de "publications de mariage"
--------------------------------------------------------
      nom_commune       | nb_publications
------------------------+-----------------
 SAINT PIERRE DU CHEMIN |              20
(1 ligne)

--------------------------------------------------------
 QUESTION 5 : La date du premier acte et le dernier acte
--------------------------------------------------------
 date_premier_acte | date_dernier_acte
-------------------+-------------------
 1581-12-23        | 1915-09-14
(1 ligne)

========================================================
                  FIN DES REQUÊTES
========================================================


Modélisation de bases de données/projet/mariages
❯
