BEGIN {
    # On définit la virgule comme séparateur de colonnes en lecture et écriture
    FS = ","
    OFS = ","
}

{

    # ==========================================
    # 1. RÉCUPÉRATION DES PERSONNES EN MÉMOIRE
    # ==========================================

    # --- Famille de la Personne A ---
    if ($3 != "n/a" && $4 != "n/a") {
        personnes[$3, $4] = 1
        # Père de A (on déduit qu'il a le même nom de famille, colonne 3)
        if ($5 != "n/a") {
            personnes[$3, $5] = 1
            pere[$3, $4] = $3 SUBSEP $5
        }
        # Mère de A (elle a son nom de jeune fille, colonnes 6 et 7)
        if ($6 != "n/a" && $7 != "n/a") {
            personnes[$6, $7] = 1
            mere[$3, $4] = $6 SUBSEP $7
        }
    }

    # --- Famille de la Personne B ---
    if ($8 != "n/a" && $9 != "n/a") {
        personnes[$8, $9] = 1
        # Père de B
        if ($10 != "n/a") {
            personnes[$8, $10] = 1
            pere[$8, $9] = $8 SUBSEP $10
        }
        # Mère de B
        if ($11 != "n/a" && $12 != "n/a") {
            personnes[$11, $12] = 1
            mere[$8, $9] = $11 SUBSEP $12
        }
    }

    # ==========================================
    # 2. SAUVEGARDE DES ACTES POUR LA FIN
    # ==========================================
    id_acte[NR]   = $1
    type_acte[NR] = $2
    nomA[NR] = $3; prenomA[NR] = $4
    nomB[NR] = $8; prenomB[NR] = $9
    commune[NR]   = $13
    dept[NR]      = $14
    date_acte[NR] = $15
    vue[NR]       = $16
}

END {
    # ==========================================
    # 3. CRÉATION DES IDS UNIQUES
    # ==========================================
    id_count = 1
    for (p in personnes) {
        id_dict[p] = id_count++
    }

    # ==========================================
    # 4. EXPORT DE LA TABLE "PERSONNE"
    # ==========================================
    # Format : id_personne, nom, prenom, id_pere, id_mere
    for (p in personnes) {
        split(p, nom_prenom, SUBSEP)

        id_pers = id_dict[p]
        id_p = (p in pere) ? id_dict[pere[p]] : "NULL"
        id_m = (p in mere) ? id_dict[mere[p]] : "NULL"

        print id_pers, nom_prenom[1], nom_prenom[2], id_p, id_m > "table_personne.csv"
    }

    # ==========================================
    # 5. EXPORT DE LA TABLE "ACTE"
    # ==========================================
    # Format : id_acte, date, num_vue, type_acte, commune, dept, fk_personne_A, fk_personne_B
    for (i = 1; i <= NR; i++) {
        fk_A = (nomA[i] != "n/a" && prenomA[i] != "n/a") ? id_dict[nomA[i], prenomA[i]] : "NULL"
        fk_B = (nomB[i] != "n/a" && prenomB[i] != "n/a") ? id_dict[nomB[i], prenomB[i]] : "NULL"

        print id_acte[i], date_acte[i], vue[i], type_acte[i], commune[i], dept[i], fk_A, fk_B > "table_acte.csv"
    }
}
