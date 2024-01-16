USE AdventureWorks2019
GO

--INSERT INTO
CREATE TABLE dbo.TAB1 (COL1 int NOT NULL, COL2 varchar(3) DEFAULT 'SIM', COL3 datetime NOT NULL);

--Especificando o nome das colunas explicitamente
SET LANGUAGE Portugu�s
GO
SELECT @@LANGUAGE
GO

INSERT INTO dbo.TAB1 (COL1, COL2, COL3)
VALUES (1,'N�O', '23/09/2019 00:00:00.000')
GO

SELECT * FROM dbo.TAB1
GO


--Especificando o nome das colunas explicitamente e a ordem de inser��o das colunas
INSERT INTO dbo.TAB1 (COL3, COL2, COL1)
VALUES ('24/09/2019 00:00:00.000', 'N�O', 2 )
GO

SELECT * FROM dbo.TAB1
GO


--Omitindo o nome das colunas
INSERT INTO dbo.TAB1
VALUES (3,'N�O', '25/09/2019 00:00:00.000')
GO

SELECT * FROM dbo.TAB1
GO


--Omitindo o nome das colunas (*Erro da Ordem)
INSERT INTO dbo.TAB1
VALUES ('N�O', '25/09/2019 00:00:00.000',4)
GO

--Se convers�o impl�cita fosse poss�vel
CREATE TABLE dbo.TAB2 (COL1 int, COL2 varchar(1))
GO

INSERT INTO dbo.TAB2
VALUES (10,20)
GO

SELECT * FROM dbo.TAB2
GO

INSERT INTO dbo.TAB2
VALUES (10,2)
GO

SELECT * FROM dbo.TAB2
GO

--Se as colunas do mesmo tipo de dados: linha com dados "inv�lidos"
CREATE TABLE dbo.TAB3 (IDADE int, COMISSAO int)
GO

INSERT INTO dbo.TAB3
VALUES (5,50)
GO

SELECT * FROM dbo.TAB3
GO


--Omitindo a Cl�usula INTO
INSERT dbo.TAB1 (COL1, COL2, COL3)
VALUES (4,'N�O', '26/09/2019 00:00:00.000')
GO

SELECT * FROM dbo.TAB1
GO


--INSERT de V�rias Linhas
INSERT dbo.TAB1 (COL1, COL2, COL3)
VALUES	(5,'SIM', '27/09/2019 00:00:00.000'),
		(6,'N�O', '28/09/2019 00:00:00.000'),
		(7,'SIM', '29/09/2019 00:00:00.000')
GO

SELECT * FROM dbo.TAB1
GO


--INSERT em Colunas com Default
EXEC SP_HELP 'dbo.TAB1'
GO

--Erro se n�o explicitar o valor
INSERT dbo.TAB1 (COL1, COL2, COL3)
VALUES	(8, , '27/09/2019 00:00:00.000')
GO

--OK
INSERT dbo.TAB1 (COL1, COL3)
VALUES	(8, '30/09/2019 00:00:00.000')
GO

SELECT * FROM dbo.TAB1
GO

--Mesmo resultado de ter executado
--INSERT dbo.TAB1 (COL1, COL2, COL3)
--VALUES	(8, DEFAULT, '30/09/2019 00:00:00.000')

INSERT dbo.TAB1 (COL1, COL2, COL3)
VALUES (9, DEFAULT, '30/09/2019 00:00:00.000')
GO

SELECT * FROM dbo.TAB1
GO


--Insert de Valores Nulos
EXEC SP_HELP 'dbo.TAB1'
GO

INSERT dbo.TAB1 (COL1, COL2, COL3)
VALUES (10, NULL, '30/09/2019 00:00:00.000')
GO

SELECT * FROM dbo.TAB1
GO


--Usando Fun��es no Insert
INSERT dbo.TAB1 (COL1, COL2, COL3)
VALUES (12, NULL, GETDATE())
GO

SELECT * FROM dbo.TAB1
GO

--INSERT x Foreign Key
ALTER TABLE dbo.TAB1 
ADD CONSTRAINT	PK_TAB1 PRIMARY KEY CLUSTERED 
(
	COL1
)
GO

CREATE TABLE dbo.TAB4 (COL4 int NOT NULL, COL1_FK int NOT NULL)
GO

ALTER TABLE dbo.TAB4 
ADD CONSTRAINT	FK_COL1_TAB1 FOREIGN KEY
(
	COL1_FK
) REFERENCES dbo.TAB1
(
	COL1
)
GO

--Erro: valor 0 para a chave estrangeira n�o foi encontrado na tabela pai
INSERT dbo.TAB4 (COL4, COL1_FK)
VALUES (1,0)
GO

INSERT dbo.TAB1 (COL1, COL2, COL3)
VALUES (0, DEFAULT, GETDATE())
GO

SELECT * FROM TAB1
GO

INSERT dbo.TAB4 (COL4, COL1_FK)
VALUES (1,0)
GO

SELECT * FROM TAB4
GO


--INSERT com Campos IDENTITY (SQL Server)
--Come�a em 1.000 e incrementa de 1 em 1
CREATE TABLE dbo.TAB5 
(
	COL5 int IDENTITY (1000, 1) NOT NULL,
	COL6 char(1) NOT NULL
)
GO

INSERT dbo.TAB5 (COL6)
VALUES	('A'),
		('B'),
		('C'),
		('D'),
		('E')
GO

SELECT * FROM dbo.TAB5
GO


--INSERT com SEQUENCE
--N�o fica atrelada � tabela \ campo
CREATE SEQUENCE dbo.SEQUENCE_TAB6
AS INT
START WITH 100
INCREMENT BY 1
GO

CREATE TABLE dbo.TAB6
(
	COL6 int NOT NULL,
	COL7 char(1) NOT NULL
)
GO

INSERT dbo.TAB6 (COL6, COL7)
VALUES	(NEXT VALUE FOR dbo.SEQUENCE_TAB6, 'A'),
		(NEXT VALUE FOR dbo.SEQUENCE_TAB6, 'B'),
		(NEXT VALUE FOR dbo.SEQUENCE_TAB6, 'C'),
		(NEXT VALUE FOR dbo.SEQUENCE_TAB6, 'D'),
		(NEXT VALUE FOR dbo.SEQUENCE_TAB6, 'E')
GO

SELECT * FROM dbo.TAB6
GO


--INSERT com SELECT
CREATE TABLE dbo.SUB_TAB6
(
	COL6 int NOT NULL,
	COL7 char(1) NOT NULL
)
GO

INSERT INTO dbo.SUB_TAB6
SELECT COL6, COL7 
FROM dbo.TAB6
WHERE COL6 >= 103
GO

SELECT * FROM dbo.SUB_TAB6
GO


--Poss�vel Usar Todos Recursos da Instru��o SELECT
INSERT INTO dbo.SUB_TAB6
SELECT TOP (1) *
FROM dbo.TAB6
ORDER BY COL6 ASC
GO

SELECT * FROM dbo.SUB_TAB6
GO


--Erro: Colunas N�o Nulas sem dados retornados pelo SELECT
EXEC SP_HELP 'dbo.SUB_TAB6'
GO
INSERT INTO dbo.SUB_TAB6
SELECT COL6 FROM dbo.TAB6
WHERE COL6 >= 103
GO


INSERT INTO dbo.SUB_TAB6
SELECT * FROM dbo.TAB1
GO
EXEC SP_HELP 'dbo.TAB1'
GO


--INSERT com EXEC
EXEC SP_HELPDB
GO

CREATE TABLE dbo.TAB_BDs
(
	NOM_BANCO		varchar(max),
	TAM_BANCO		varchar(255),
	NOM_PROPIETARIO varchar(255),
	ID_BANCO		int,
	DAT_CRIACAO		datetime,
	DSC_STATUS		varchar(max),
	DSC_COMPATIB	smallint
)
GO

INSERT dbo.TAB_BDs
EXEC SP_HELPDB
GO

SELECT * FROM dbo.TAB_BDs
GO






--SELECT INTO
EXEC SP_HELP 'dbo.TAB1'
GO

SELECT *  
INTO dbo.TAB1_COPIA 
FROM dbo.TAB1
GO

SELECT * FROM dbo.TAB1_COPIA
GO
SELECT * FROM dbo.TAB1
GO

EXEC SP_HELP 'dbo.TAB1_COPIA'
GO
EXEC SP_HELP 'dbo.TAB1'
GO


--Possibilidade Usar as Diversas Op��es para uma Instru��o SELECT
SELECT sp.BusinessEntityID, c.LastName, c.FirstName, sp.SalesYTD   
INTO dbo.TOP_EmployeeSales
FROM Sales.SalesPerson AS sp  INNER JOIN Person.Person AS c  
ON sp.BusinessEntityID = c.BusinessEntityID  
WHERE sp.SalesYTD > 250000.00
GO

SELECT * FROM dbo.TOP_EmployeeSales
GO
SELECT * FROM Sales.SalesPerson
GO


--INSERT COM SCRIPT DA INTERFACE GR�FICA DO CLIENT
--INSERT COM INTERFACE GR�FICA DO CLIENT

