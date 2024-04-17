-- Create Author table
drop table if exists Author cascade;
CREATE TABLE Author
(
    ID        INT PRIMARY KEY NOT NULL UNIQUE,
    FirstName VARCHAR(255)    NOT NULL,
    LastName  VARCHAR(255)    NOT NULL,
    BirthDate DATE            NOT NULL,
    DeathDate DATE CHECK (DeathDate > BirthDate),
    Biography TEXT,
    Country   VARCHAR(255)
);

-- Create Painting table
drop table if exists Painting cascade;
CREATE TABLE Painting
(
    ID          INT PRIMARY KEY NOT NULL UNIQUE,
    Title       VARCHAR(255)    NOT NULL,
    Year        INT             NOT NULL CHECK ( Year < extract(YEAR from now()) ),
    Technique   VARCHAR(255),
    Genre       VARCHAR(255),
    Description TEXT,
    AuthorID    INT,
    FOREIGN KEY (AuthorID) REFERENCES Author (ID)
);

-- Create Sculpture table
drop table if exists Sculpture cascade;
CREATE TABLE Sculpture
(
    ID          INT PRIMARY KEY NOT NULL UNIQUE,
    Title       VARCHAR(255)    NOT NULL,
    Year        INT             NOT NULL CHECK ( Year < extract(YEAR from now()) ),
    Material    VARCHAR(255),
    Description TEXT,
    AuthorID    INT,
    FOREIGN KEY (AuthorID) REFERENCES Author (ID)
);

-- Create Exhibition table
drop table if exists Exhibition cascade;
CREATE TABLE Exhibition
(
    ID          INT PRIMARY KEY NOT NULL UNIQUE,
    Name        VARCHAR(255)    NOT NULL,
    Description TEXT,
    StartDate   DATE            NOT NULL,
    EndDate     DATE            NOT NULL CHECK (EndDate > StartDate)
);

-- Create MuseumEmployee table
drop table if exists MuseumEmployee cascade;
CREATE TABLE MuseumEmployee
(
    ID          INT PRIMARY KEY NOT NULL UNIQUE,
    FirstName   VARCHAR(255)    NOT NULL,
    LastName    VARCHAR(255)    NOT NULL,
    Position    VARCHAR(255),
    ContactInfo VARCHAR(255)
);

-- Create Visitor table
drop table if exists Visitor cascade;
CREATE TABLE Visitor
(
    ID        INT PRIMARY KEY NOT NULL UNIQUE,
    FirstName VARCHAR(255)    NOT NULL,
    LastName  VARCHAR(255)    NOT NULL,
    BirthDate DATE            NOT NULL CHECK ( BirthDate < now() )
);

-- Create Exhibition_Painting table
drop table if exists Exhibition_Painting cascade;
CREATE TABLE Exhibition_Painting
(
    PaintingID   INT NOT NULL,
    ExhibitionID INT NOT NULL,
    PRIMARY KEY (PaintingID, ExhibitionID),
    FOREIGN KEY (PaintingID) REFERENCES Painting (ID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibition (ID)
);

-- Create Exhibition_Sculpture table
drop table if exists Exhibition_Sculpture cascade;
CREATE TABLE Exhibition_Sculpture
(
    SculptureID  INT NOT NULL,
    ExhibitionID INT NOT NULL,
    PRIMARY KEY (SculptureID, ExhibitionID),
    FOREIGN KEY (SculptureID) REFERENCES Sculpture (ID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibition (ID)
);

-- Create Exhibition_MuseumEmployee table
drop table if exists Exhibition_MuseumEmployee cascade;
CREATE TABLE Exhibition_MuseumEmployee
(
    ExhibitionID     INT NOT NULL,
    MuseumEmployeeID INT NOT NULL,
    PRIMARY KEY (ExhibitionID, MuseumEmployeeID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibition (ID),
    FOREIGN KEY (MuseumEmployeeID) REFERENCES MuseumEmployee (ID)
);

-- Create Exhibition_Visitor table
drop table if exists Exhibition_Visitor cascade;
CREATE TABLE Exhibition_Visitor
(
    ExhibitionID INT NOT NULL,
    VisitorID    INT NOT NULL,
    PRIMARY KEY (ExhibitionID, VisitorID),
    FOREIGN KEY (ExhibitionID) REFERENCES Exhibition (ID),
    FOREIGN KEY (VisitorID) REFERENCES Visitor (ID)
);
x

