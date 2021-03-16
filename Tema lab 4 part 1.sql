USE BIBLIOTECA

--functia verifica daca o carte se gaseste in baza de date
GO
CREATE OR ALTER FUNCTION ExistaCarte ( @id INT)
RETURNS INT AS
BEGIN
IF EXISTS(SELECT 1 FROM Carti WHERE codCarte=@id)
BEGIN
RETURN 1;
END
RETURN 0;
END

GO
CREATE OR ALTER FUNCTION ExistaAutor (@idAutor int)
returns int as
begin
if exists(select 1 from Autori where codAutor=@idAutor)
begin
return 1;
end 
return 0;
end

-- functia verifica daca nr de pagini este mai mare decat 5
GO
CREATE OR ALTER  FUNCTION NrPaginiPozitiv ( @nrPagini INT)
RETURNS INT AS
BEGIN
IF (@nrPagini > 5)
BEGIN
RETURN 1;
END
RETURN 0;
END


-- functia verifica codul editurii sa fie in BD
GO
CREATE OR ALTER FUNCTION CodEdituraExistent ( @id int)
RETURNS INT AS
BEGIN
IF EXISTS(SELECT 1 FROM Edituri WHERE codEditura=@id)
BEGIN
RETURN 1;
END
RETURN 0;
END

-- numele cartii exista deja in bd
GO
CREATE FUNCTION numeCarteExistent (@numeCarte VARCHAR(60))
RETURNS INT AS
BEGIN 
IF EXISTS(select 1 from Carti where denumireCarte = @numeCarte)
BEGIN
return 1;
end
return 0;
end

-- procedura care adauga o carte in baza de date
GO
CREATE OR ALTER PROCEDURE AdaugaCarte @denumireCarte VARCHAR(60),@nrPagini INT, @codEditura INT
AS
BEGIN
DECLARE @idCarte INT;
DECLARE @testNrPagPozitiv int;
declare @codEdExistent int;
declare @testDenumireCarte int;
SELECT @testNrPagPozitiv = dbo.NrPaginiPozitiv(@nrPagini)
SELECT @codEdExistent = dbo.CodEdituraExistent(@codEditura)
IF (@testNrPagPozitiv=1 AND @codEdExistent=1)
BEGIN
INSERT INTO Carti (denumireCarte, nrPagini, codEditura) VALUES ( @denumireCarte,
@nrPagini, @codEditura)
PRINT 'S-a inserat inregistrearea in tabelul Carti';
END
IF (@codEdExistent=0)
BEGIN
PRINT 'Nu exista editura';
END
IF( @testNrPagPozitiv=0)
BEGIN
PRINT 'Cartea trebuie sa aiba peste 5 pagini!'
END
END

select * from Carti

GO
EXEC AdaugaCarte 'Fima',204,100 -- Nu exista editura 
EXEC AdaugaCarte 'Test',4,12 -- Valoare sub 5 a numarului de pagini
EXEC AdaugaCarte 'Mancarea e buna', 201, 11 -- S-a inserat inregistrarea in tabel


-- procedura ce introduce valori in tabelul de legatura Carti_Autori

GO
CREATE OR ALTER PROCEDURE AdaugaLegaturaCarteAutor @idCarte int, @idAutor int
AS
BEGIN
DECLARE @existaCarte INT;
DECLARE @existaAutor int;
SELECT @existaCarte = dbo.ExistaCarte(@idCarte)
SELECT @existaAutor = dbo.ExistaAutor(@idAutor)
IF (@existaCarte=1 AND @existaAutor=1)
BEGIN
INSERT INTO Carti_Autori (codCarte, codAutor) VALUES ( @idCarte, @idAutor)
PRINT 'S-a inserat inregistrearea in tabelul Carti_Autori';
END
IF (@existaCarte=0)
BEGIN
PRINT 'Nu exista cartea';
END
IF( @existaAutor=0)
BEGIN
PRINT 'Nu exista autorul!'
END
END

SELECT * from Autori
SELECT * from Carti
select * from Carti_Autori

GO
EXEC AdaugaLegaturaCarteAutor 137, 22 -- Ar trebui sa mearga
EXEC AdaugaLegaturaCarteAutor 250,22 -- Nu exista cartea



-- functie de verifica daca anul de infiintare al editurii este mai mare decat 1900
GO
CREATE FUNCTION anInfiintareValid (@an INT)
RETURNS INT AS
BEGIN 
IF (@an > 1900)
BEGIN
return 1;
end
return 0;
end


-- procedura care insereaza o editura
GO
CREATE PROCEDURE AdaugaEditura  @numeEditura varchar(60), @anInfiintare int
AS
BEGIN
DECLARE @anValid INT;
SELECT @anValid = dbo.anInfiintareValid(@anInfiintare)
IF (@anValid = 1)
BEGIN
INSERT INTO Edituri (denumireEditura, anInfiintare) VALUES ( @numeEditura, @anInfiintare)
PRINT 'S-a inserat inregistrearea in tabelul Edituri';
END
IF (@anValid=0)
BEGIN
PRINT 'Anul nu este valid';
END
END

select * from Edituri

GO
EXEC AdaugaEditura Trei, 1970 -- Ar trebui sa mearga
EXEC AdaugaEditura Polirom, 1000 -- Nu exista cartea


-- procedura care adauga exemplare
GO
CREATE PROCEDURE AdaugaExemplar  @codExemplar int, @peRaft bit
AS
BEGIN
DECLARE @existaCodExemplar INT;
SELECT @existaCodExemplar = dbo.ExistaCarte(@codExemplar)
IF (@existaCodExemplar = 1)
BEGIN
INSERT INTO Exemplare (codExemplar, peRaft) VALUES ( @codExemplar, @peRaft)
PRINT 'S-a inserat inregistrearea in tabelul Exemplare';
END
IF (@existaCodExemplar=0)
BEGIN
PRINT 'Cartea nu exista in baza de date';
END
END
select * from Exemplare
GO
EXEC AdaugaExemplar 230, 1 -- Ar trebui sa mearga
EXEC AdaugaExemplar 789, 0 -- Nu exista cartea

-- verificam daca exemplarul este pe raft
-- nu stiu cum sa fac functia asta
GO
CREATE FUNCTION estePeRaft (@codExemplar INT)
RETURNS INT AS
BEGIN 
IF exists(select 1 from Exemplare where codExemplar=@codExemplar and peRaft=1)
BEGIN
return 1;
end
return 0;
end

-- procedura pentru introducerea de date in tabelul Imprumuturi

GO
CREATE PROCEDURE AdaugaImprumut  @codExemplar int, @codCititor int, @dataImprumut date
AS
BEGIN
DECLARE @existaCodExemplar INT;
DECLARE @estePeRaft INT;
SELECT @existaCodExemplar = dbo.ExistaCarte(@codExemplar)
SELECT @estePeRaft = dbo.estePeRaft(@codExemplar)
IF (@existaCodExemplar = 1)
BEGIN
INSERT INTO Imprumuturi (codExemplar, codCititor, dataImprumut) VALUES ( @codExemplar, @codCititor, @dataImprumut)
PRINT 'S-a inserat inregistrearea in tabelul Exemplare';
END
IF (@existaCodExemplar=0)
BEGIN
PRINT 'Exemplarul nu este in biblioteca!';
END
IF (@estePeRaft = 0)
Begin
print 'Exemplarul nu este pe raft'
END
END

select * from Exemplare
select * from Carduri
GO
EXEC AdaugaImprumut 5, 6, '2020-12-09' -- Ar trebui sa mearga
EXEC AdaugaImprumut 789, 0, ' ' -- Nu va functiona

