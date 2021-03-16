USE Biblioteca;

CREATE TABLE Statusuri
( numeStatus VARCHAR (60) PRIMARY KEY);

ALTER TABLE Carduri
ADD statusCititor VARCHAR(60) FOREIGN KEY REFERENCES Statusuri;

CREATE TABLE Imprumuturi
( cod INT PRIMARY KEY IDENTITY,
codCarte INT FOREIGN KEY REFERENCES Carti,
codCititor INT FOREIGN KEY REFERENCES Carduri,
dataImprumut DATE DEFAULT GETDATE());

-- aici as vrea sa mai adaug si o eventuala intarziere.

ALTER TABLE Imprumuturi
ADD CONSTRAINT uq_imprumut_carte UNIQUE (codCarte);