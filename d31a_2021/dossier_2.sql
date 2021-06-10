question 1 :

create table Tuteur (
    
    idtuteur int primary key auto_increment,  
nom   varchar(50), 
prenom varchar(50),
 email  varchar(50), 
 tel varchar(50), 
 
 identreprise int ,
 constraint fk_tuteur_entreprise foreign key(identreprise) references entreprise (identreprise)
 
 )



create table  stage (
numero int primary key auto_increment,
datedebut date,
datefin date,
duree int ,
description text,
noteStage float,
mention varchar(50),
situation varchar(50),
idetudiant int ,
idprof int ,
idtuteur int , 
identreprise int ,
constraint fk_stage_etudiant foreign key(idetudiant) references etudiant(idetudiant),
constraint fk_stage_prof foreign key(idprof) references professeur(idprof),
constraint fk_stage_tuteur foreign key(idtuteur) references tuteur(idtuteur),
constraint fk_stage_entreprise foreign key(identreprise) references entreprise(identreprise)

)

question 2 :



insert into tuteur (nom,prenom,email,tel,identreprise) values('Dupond','Kevin','k.Dupond@gmail.com','0102030405',2)
insert into stage(datedebut,datefin,description,noteStage,mention,situation,idetudiant,idprof,idtuteur,identreprise)
values ('2021-05-05','2021-07-05','Stage en fin d’année de master 1, Implantation d’une technique de tri',
 15/20,'Très bien, bonne présentation des livrables','terminé',3,2,6,4) 
)


question 3 : 

Rédigez les requêtes donnant les états suivants :
a) La liste des stages : description, date de début, date de fin, situation, nom de l’entreprise,
nom du tuteur, prénom du tuteur, email et téléphone du tuteur.
b) La liste des étudiants : nom, prénom, avec leur diplôme obtenu, code, libellé, date
d’obtention et mention.
c) La liste des professeurs : nom, prénom et le nombre de stages qu’ils ont respectivement
suivis durant l’année 2021.
d) La liste des secteurs d’activités des entreprises avec le nombre de stages qu’offre chaque
secteur.
e) La liste des étudiants qui ont terminé leur stage avant la fin juillet 2021 et qui ont déjà
obtenu un diplôme de « master 1 ».

a) 
select stage.description,stage.datedebut,stage.datefin,stage.situation,entreprise.nom, tuteur.nom,tuteur.prenom,
tuteur.email,tuteur.tel
from stage join entreprise  on  stage.identreprise=entreprise.identreprise

b)
select etudiant.nom,etudiant.prenom,diplome.code,diplome.libelle, preparer.dateObtention,preparer.mention
from etudiant join preparer on etudiant.idetudiant=preparer.idetudiant
join diplome on diplome.code=preparer.code 

c)

select nom,prenom , count(*) from professeur join stage on professeur.idprof=stage.idprof
group by nom , prenom 
where year(datedebut)=2021



d)

select secteurActivite , count(*) from entreprise join stage on entreprise.identreprise=stage.identreprise

group by secteurActivite

e)
La liste des étudiants qui ont terminé leur stage avant la fin juillet 2021 et qui ont déjà
obtenu un diplôme de « master 1 ».

select etudiant.* from etudiant 
join  stage on etudiant.idetudiant=stage.idetudiant
join preparer on etudiant.idetudiant=preparer.idetudiant
join diplome on preparer.code=diplome.code
where datefin < '2021-07-31' and libelle='master 1'

question 4 : 

alter table entreprise add column  nbStages int 


question 5 :


Chaque année, un état des lieux est effectué sur la table Stage. Tous les stages dont la situation est « en
cours » ou « confirmé » seront supprimés de la table. En effet, les stages avec une situation « terminée »
seront déplacés dans une table nommée « H_Stage » qui gardera l’historique des stages des étudiants ayant
terminé leur cursus à l’école.
Écrivez la requête de suppression qui sera exécutée en fin d’année.


delete from stage where situation in ('en cours','confirmé')

Question 6 :
create or replace trigger incrementer_nbStage
 after insert on stage 
 for each row
begin 
update entreprise set nbStages=nbStages+1 where identreprise= :new.identreprise;
end ;

create or replace trigger decrementer_nbStage
 after delete on stage 
 for each row 
begin 
update entreprise set nbStages=nbStages-1 where identreprise= :old.identreprise;
end ;


