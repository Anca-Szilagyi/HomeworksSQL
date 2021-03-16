USE Biblioteca;

CREATE TABLE Autori
( codAutor INT PRIMARY KEY IDENTITY,
numeAutor VARCHAR(60),
nationalitate VARCHAR(60));

CREATE TABLE Edituri
(codEditura INT PRIMARY KEY IDENTITY,
denumireEditura VARCHAR(60) NOT NULL,
anInfiintare INT CHECK (anInfiintare>1700));

CREATE TABLE Carti
( codCarte INT PRIMARY KEY IDENTITY,
denumireCarte VARCHAR(60) NOT NULL,
nrPagini INT,
codEditura INT FOREIGN KEY REFERENCES Edituri(codEditura));

CREATE TABLE Carduri
( codClient INT PRIMARY KEY IDENTITY,
numeClient VARCHAR(80) NOT NULL,
dataNasterii DATE,
observatii VARCHAR(150));

CREATE TABLE Carti_Autori
( codCarte INT FOREIGN KEY REFERENCES Carti(codCarte),
codAutor INT FOREIGN KEY REFERENCES Autori(codAutor),
CONSTRAINT pk_CartiAutori PRIMARY KEY (codCarte, codAutor));

CREATE TABLE Edituri_Carti
( codEditura INT FOREIGN KEY REFERENCES Edituri (codEditura),
codCarteAutor INT FOREIGN KEY REFERENCES Carti_Autori (pk_CartiAutori));