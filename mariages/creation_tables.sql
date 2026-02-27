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
