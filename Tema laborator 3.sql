SELECT codAutor from Autori 
EXCEPT
SELECT codAutor from Carti_Autori 

SELECT Carduri.numeClient, Carduri.dataNasterii, Carduri.observatii, Carti.denumireCarte from Carduri
inner join Imprumuturi ON Carduri.codClient = Imprumuturi.codCititor
inner join Exemplare ON Imprumuturi.codExemplar = Exemplare.codExemplar
inner join Carti on Exemplare.codExemplar = Carti.codCarte

--FULL JOIN, RIGHT JOIN SI LEFT JOIN in functie de nevoie
-- extrage numele cartii, autorul si numarul de pagini pentru fiecare carte si pentru fiecare autor, 
-- indiferent daca acestea au un corespondent in tabelul de legatura

SELECT  Carti.denumireCarte, Autori.numeAutor, Carti.nrPagini FROM Carti
FULL JOIN [Carti_Autori] ON Carti_AUtori.codCarte=Carti.codCarte
Left JOIN [Autori] ON Carti_Autori.codAutor=Autori.codAutor;


SELECT count(codCarte) nrCarti, nrPagini
FROM Carti
GROUP BY nrPagini
HAVING nrPagini> 205;


SELECT * FROM Autori
WHERE nationalitate='roman' or nationalitate='american';

Select distinct nationalitate from Autori
