-- DROP THE DATABASE --
SET NOCOUNT ON
USE [master]
GO
DROP DATABASE FIRM_db
GO

-- CREATE NEW DATABASE --
CREATE DATABASE FIRM_db
GO
USE FIRM_db
GO

-- CREATE TABLES --
CREATE TABLE [Description]											(
		Id				int				NOT NULL	IDENTITY(0,1)	,
		[Value]			nvarchar(max)	NOT NULL					,
		DateCreated		datetime		NOT NULL	DEFAULT GETDATE( )
	CONSTRAINT pk_Description PRIMARY KEY ( Id )					)
	GO
	INSERT [Description] SELECT '', GETDATE( )
	GO

CREATE TABLE Repository												(
		Id				int				NOT NULL	IDENTITY(0,1)	,
		[Name]			varchar(64)		NOT NULL					,
		DescriptionId	int				NOT NULL					,
		ReferenceOnly	bit				NOT NULL	DEFAULT 0
	CONSTRAINT pk_Repository PRIMARY KEY ( Id )						,
	CONSTRAINT fk_Repository_Description FOREIGN KEY ( DescriptionId ) REFERENCES [Description] ( Id ) )
	GO
	INSERT Repository SELECT '<BLANK>', 0, 1
	GO

CREATE TABLE Notebook												(
		Id				int				NOT NULL	IDENTITY(0,1)	,
		[Name]			varchar(64)		NOT NULL					,
		RepositoryId	int				NOT NULL					,
		DescriptionId	int				NOT NULL					
	CONSTRAINT pk_Notebook PRIMARY KEY ( Id )						,
	CONSTRAINT fk_Notebook_Repository  FOREIGN KEY ( RepositoryId  ) REFERENCES Repository    ( Id ),
	CONSTRAINT fk_Notebook_Description FOREIGN KEY ( DescriptionId ) REFERENCES [Description] ( Id ) )
	GO
	INSERT Notebook SELECT '<BLANK>', 0, 0
	GO

CREATE TABLE NotebookItem											(
		NotebookId		int				NOT NULL					,
		Line			int				NOT NULL					,
		DescriptionId	int				NOT NULL					
	CONSTRAINT pk_NotebookItem PRIMARY KEY ( NotebookId, Line )		,
	CONSTRAINT fk_NotebookItem_Notebook    FOREIGN KEY ( NotebookId )    REFERENCES Notebook      ( Id ),
	CONSTRAINT fk_NotebookItem_Description FOREIGN KEY ( DescriptionId ) REFERENCES [Description] ( Id ) )
	GO
	INSERT NotebookItem SELECT 0, 0, 0
	GO

CREATE TABLE Campaign												(
		Id				int				NOT NULL	IDENTITY(0,1)	,
		[Name]			varchar(64)		NOT NULL					,
		Active			bit				NOT NULL	DEFAULT 1		,
		RepositoryId	int				NOT NULL					,
		DescriptionId	int				NOT NULL					,
		NotebookId		int				NOT NULL
	CONSTRAINT pk_Campaign PRIMARY KEY ( Id )						,
	CONSTRAINT fk_Campaign_Repository  FOREIGN KEY ( RepositoryId )  REFERENCES Repository    ( Id ),
	CONSTRAINT fk_Campaign_Description FOREIGN KEY ( DescriptionId ) REFERENCES [Description] ( Id ),
	CONSTRAINT fk_Campaign_Notebook    FOREIGN KEY ( NotebookId )    REFERENCES Notebook      ( Id ) )
	GO
	INSERT Campaign SELECT '<BLANK>', 0, 0, 0, 0
	GO

CREATE TABLE CampaignRepository										(
		CampaignId		int				NOT NULL					,
		RepositoryId	int				NOT NULL					,
		ReferenceOnly	bit				NOT NULL	DEFAULT 0
	CONSTRAINT pk_CampaignRepository PRIMARY KEY ( CampaignId, RepositoryId ),
	CONSTRAINT fk_CampaignRepository_Campaign   FOREIGN KEY ( CampaignId )   REFERENCES Campaign   ( Id ),
	CONSTRAINT fk_CampaignRepository_Repository FOREIGN KEY ( RepositoryId ) REFERENCES Repository ( Id ) )
	GO
	INSERT CampaignRepository SELECT 0, 0, 1
	GO

CREATE TABLE Unit													(
		Id				int				NOT NULL	Identity(0,1)	,
		[Name]			varchar(64)		NOT NULL					,
		Abbreviation	varchar(16)		NOT NULL					,
		UnitType		char(1)			NOT NULL					
	CONSTRAINT pk_Unit PRIMARY KEY ( Id )							,
	CONSTRAINT uq_Unit_TypeAbbreviation UNIQUE ( UnitType, Abbreviation ),
	CONSTRAINT uq_Unit_TypeName         UNIQUE ( UnitType, [Name] )	)
	GO
	INSERT Unit SELECT '<NONE>', '', ''
	GO

CREATE TABLE Measurement											(
		Id				int				NOT NULL	Identity(0,1)	,
		Quantity		numeric(20,4)	NOT NULL					,
		UnitId			int				NOT NULL					
	CONSTRAINT pk_Measurement PRIMARY KEY ( Id )					,
	CONSTRAINT fk_Measurement_Unit FOREIGN KEY ( UnitId ) REFERENCES Unit ( Id ) )
	GO
	INSERT Measurement SELECT 0, 0
	GO

CREATE TABLE [Image]												(
		Id				int				NOT NULL	Identity(0,1)	,
		RepositoryId	int				NOT NULL					,
		[Data]			varbinary			NULL					
	CONSTRAINT pk_Image PRIMARY KEY ( Id )							,
	CONSTRAINT fk_Image_Repository FOREIGN KEY ( RepositoryId ) REFERENCES Repository ( Id ) )
	GO
	INSERT [Image] SELECT 0, NULL
	GO

CREATE TABLE Album													(
		Id				int				NOT NULL	Identity(0,1)	,
		[Name]			varchar(64)		NOT NULL					,
		RepositoryId	int				NOT NULL					,
	CONSTRAINT pk_Album PRIMARY KEY ( Id )							,
	CONSTRAINT fk_Album_Repository FOREIGN KEY ( RepositoryId ) REFERENCES Repository ( Id ) )
	GO
	INSERT Album SELECT '<BLANK>', 0
	GO

CREATE TABLE Inventory												(
		Id				int				NOT NULL	IDENTITY(0,1)	,
		[Name]			varchar(64)		NOT NULL					,
		RepositoryId	int				NOT NULL					,
		DescriptionId	int				NOT NULL					
	CONSTRAINT pk_Inventory PRIMARY KEY ( Id )						,
	CONSTRAINT fk_Inventory_Repository  FOREIGN KEY ( RepositoryId )  REFERENCES Repository    ( Id ),
	CONSTRAINT fk_Inventory_Description FOREIGN KEY ( DescriptionId ) REFERENCES [Description] ( Id ) )
	GO
	INSERT Inventory SELECT '<BLANK>', 0, 0
	GO

CREATE TABLE InventoryItem											(
		InventoryId		int				NOT NULL					,
		ItemId			int				NOT NULL					, -- not handled
		QuantityId		int				NOT NULL					, -- not handled
		BatchId			int				NOT NULL					  -- not handled
	CONSTRAINT pk_InventoryItem PRIMARY KEY ( InventoryId, ItemId )	,
	CONSTRAINT fk_InventoryItem_InventoryId FOREIGN KEY ( InventoryId ) REFERENCES Inventory ( Id ) )
	GO
	INSERT InventoryItem SELECT 0, 0, 0, 0
	GO
