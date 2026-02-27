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
