--Nombre de clients
SELECT count(CLI_ID) FROM T_CLIENT

--Les clients triés sur le titre et le nom
SELECT TIT_CODE as TITRE, CLI_NOM as NOM FROM T_CLIENT ORDER BY NOM ASC

--Les clients triés sur le libellé du titre et le nom
SELECT CLI_NOM, T_TITRE.TIT_LIBELLE
FROM T_CLIENT, T_TITRE
WHERE T_CLIENT.TIT_CODE=T_TITRE.TIT_CODE
ORDER BY TIT_LIBELLE

--Les clients commençant par 'B'
SELECT CLI_NOM FROM T_CLIENT WHERE CLI_NOM like "B%"

--Les clients homonymes
SELECT CLI_NOM
FROM T_CLIENT C
WHERE (SELECT count(CLI_NOM)
FROM T_CLIENT
WHERE CLI_NOM=C.CLI_NOM)>=2

--Nombre de titres différents
SELECT count(rowid) FROM T_TITRE

--Nombre d'enseignes
SELECT count(CLI_ENSEIGNE) FROM T_CLIENT WHERE CLI_ENSEIGNE NOT NULL

--Les clients qui représentent une enseigne 
SELECT CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE FROM T_CLIENT WHERE CLI_ENSEIGNE NOT NULL

--Les clients qui représentent une enseigne de transports
SELECT CLI_NOM, CLI_PRENOM, CLI_ENSEIGNE FROM T_CLIENT WHERE CLI_ENSEIGNE NOT NULL
AND CLI_ENSEIGNE like '%transport%'

--Nombre d'hommes,Nombres de femmes, de demoiselles, Nombres de sociétés


--Nombre d''emails
SELECT count(rowid) FROM T_EMAIL

--Client sans email 
SELECT CLI_ID,CLI_NOM
FROM T_CLIENT
WHERE CLI_ID not in (SELECT CLI_ID FROM T_EMAIL)

--Clients sans téléphone 
SELECT count(CLI_ID)
FROM T_CLIENT
WHERE CLI_ID not in (SELECT CLI_ID FROM T_TELEPHONE)

--Les phones des clients
SELECT distinct(T_TELEPHONE.TEL_NUMERO)
FROM T_TELEPHONE

--Ventilation des phones par catégorie
SELECT TEL_NUMERO,TYP_CODE
FROM T_TELEPHONE
ORDER BY TYP_CODE ASC

--Les clients ayant plusieurs téléphones
SELECT CLI_ID, TEL_NUMERO
FROM T_TELEPHONE C
WHERE (SELECT count(*)
FROM T_TELEPHONE
WHERE CLI_ID = C.CLI_ID) >= 1
ORDER BY CLI_ID ASC

--Clients sans adresse:
SELECT CLI_NOM as Nom
FROM T_CLIENT
WHERE CLI_ID not in (SELECT CLI_ID FROM T_ADRESSE)

--Clients sans adresse mais au moins avec mail ou phone 
SELECT CLI_NOM as Nom
FROM T_CLIENT
WHERE CLI_ID not in (SELECT CLI_ID FROM T_ADRESSE)
AND CLI_ID in (SELECT CLI_ID FROM T_EMAIL)
OR CLI_ID in (SELECT CLI_ID FROM T_TELEPHONE)

--Dernier tarif renseigné
SELECT TRF_DATE_DEBUT
FROM T_TARIF
WHERE TRF_DATE_DEBUT IN (SELECT max(TRF_DATE_DEBUT) FROM T_TARIF);

--Tarif débutant le plus tôt 
SELECT TRF_DATE_DEBUT
FROM T_TARIF
WHERE TRF_DATE_DEBUT IN (SELECT min(TRF_DATE_DEBUT) FROM T_TARIF);

--Différentes Années des tarifs
SELECT distinct(strftime('%Y',TRF_DATE_DEBUT)) as année 
FROM T_TARIF

--Nombre de chambres de l'hotel 
SELECT CHB_ID
FROM T_CHAMBRE

--Nombre de chambres par étage


--Chambres sans telephone
SELECT CHB_ID
FROM T_CHAMBRE
WHERE CHB_POSTE_TEL is NULL

--Existence d'une chambre n°13 ?
SELECT CHB_NUMERO,CHB_ID
FROM T_CHAMBRE
WHERE CHB_NUMERO='13'

--Chambres avec sdb
SELECT CHB_NUMERO,CHB_ID
FROM T_CHAMBRE
WHERE CHB_BAIN=1

--Chambres avec douche
SELECT CHB_NUMERO,CHB_ID
FROM T_CHAMBRE
WHERE CHB_DOUCHE=1

--Chambres avec WC
SELECT CHB_NUMERO,CHB_ID
FROM T_CHAMBRE
WHERE CHB_WC=1

--Chambres sans WC séparés
SELECT CHB_NUMERO,CHB_ID
FROM T_CHAMBRE
WHERE CHB_BAIN=1
AND CHB_WC=1

--Quels sont les étages qui ont des chambres sans WC séparés ?
SELECT distinct (CHB_ETAGE)
FROM T_CHAMBRE
WHERE CHB_BAIN=1
AND CHB_WC=1

--Nombre d'équipements sanitaires par chambre trié par ce nombre d'équipement croissant

--Chambres les plus équipées et leur capacité

--Repartition des chambres en fonction du nombre d'équipements et de leur capacité

--Nombre de clients ayant utilisé une chambre
SELECT distinct(CHB_PLN_CLI_NB_PERS), CHB_ID
FROM TJ_CHB_PLN_CLI

--Clients n'ayant jamais utilisé une chambre (sans facture)
SELECT CLI_ID
FROM T_FACTURE
WHERE FAC_ID=0

--Nom et prénom des clients qui ont une facture
SELECT distinct(T_CLIENT.CLI_NOM), T_CLIENT.CLI_PRENOM
FROM T_FACTURE, T_CLIENT
WHERE T_FACTURE.CLI_ID=T_CLIENT.CLI_ID
AND T_FACTURE.FAC_ID>=1

--Nom, prénom, telephone des clients qui ont une facture
SELECT distinct(T_CLIENT.CLI_NOM), T_CLIENT.CLI_PRENOM, T_TELEPHONE.TEL_NUMERO
FROM T_FACTURE, T_CLIENT, T_TELEPHONE
WHERE T_FACTURE.CLI_ID=T_CLIENT.CLI_ID
AND T_CLIENT.CLI_ID=T_TELEPHONE.CLI_ID
AND T_FACTURE.FAC_ID>=1

--Attention si email car pas obligatoire : jointure externe

--Adresse où envoyer factures aux clients
SELECT distinct(T_ADRESSE.ADR_LIGNE1), T_ADRESSE.ADR_LIGNE2, T_ADRESSE.ADR_LIGNE3, T_ADRESSE.CLI_ID
FROM T_ADRESSE, T_FACTURE
WHERE T_ADRESSE.CLI_ID=T_FACTURE.CLI_ID
AND T_FACTURE.FAC_ID>=1

--Répartition des factures par mode de paiement (libellé)
SELECT distinct(T_MODE_PAIEMENT.PMT_LIBELLE), T_FACTURE.CLI_ID
FROM T_FACTURE, T_MODE_PAIEMENT
WHERE T_FACTURE.PMT_CODE=T_MODE_PAIEMENT.PMT_CODE
ORDER BY CLI_ID ASC

--Répartition des factures par mode de paiement 
SELECT distinct(T_FACTURE.PMT_CODE), T_FACTURE.CLI_ID
FROM T_FACTURE, T_MODE_PAIEMENT
WHERE T_FACTURE.PMT_CODE=T_MODE_PAIEMENT.PMT_CODE
ORDER BY CLI_ID ASC

--Différence entre ces 2 requêtes ? 

--Factures sans mode de paiement 
SELECT FAC_ID
FROM T_FACTURE
WHERE PMT_CODE=0

--Repartition des factures par Années
SELECT distinct(strftime('%Y',FAC_DATE)) as année
FROM T_FACTURE
ORDER BY FAC_DATE ASC

--Repartition des clients par ville
SELECT T_ADRESSE.ADR_VILLE, T_CLIENT.CLI_NOM, T_CLIENT.CLI_PRENOM
FROM T_ADRESSE, T_CLIENT
WHERE T_ADRESSE.CLI_ID=T_CLIENT.CLI_ID
ORDER BY T_ADRESSE.ADR_VILLE ASC

--Montant TTC de chaque ligne de facture (avec remises)

--Classement du montant total TTC (avec remises) des factures

--Tarif moyen des chambres par années croissantes
SELECT avg(TRF_TAUX_TAXES), strftime('%Y',TRF_DATE_DEBUT) as année
FROM T_TARIF
GROUP BY année ORDER BY année ASC

--Tarif moyen des chambres par étage et années croissantes

--Chambre la plus cher et en quelle année
SELECT max(TRF_CHB_PRIX), TRF_DATE_DEBUT
From TJ_TRF_CHB

--Chambre la plus cher par année 
SELECT distinct(strftime('%Y',TRF_DATE_DEBUT))  , TRF_CHB_PRIX
From TJ_TRF_CHB
ORDER BY strftime('%Y',TRF_DATE_DEBUT) desc

--Clasement décroissant des réservation des chambres 

--Classement décroissant des meilleurs clients par nombre de réservations

--Classement des meilleurs clients par le montant total des factures

--Factures payées le jour de leur édition

--Facture dates et Délai entre date de paiement et date d'édition de la facture