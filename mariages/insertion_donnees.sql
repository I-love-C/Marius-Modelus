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
