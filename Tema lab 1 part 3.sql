create table Exemplare
( idExemplar INT PRIMARY KEY IDENTITY,
codExemplar INT FOREIGN KEY REFERENCES Carti(codCarte),
peRaft BIT)

CREATE TABLE Imprumuturi
( cod INT PRIMARY KEY IDENTITY,
codExemplar INT FOREIGN KEY REFERENCES Exemplare,
codCititor INT FOREIGN KEY REFERENCES Carduri,
dataImprumut DATE DEFAULT GETDATE());

