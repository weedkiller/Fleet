BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION


CREATE TABLE dbo.InspectionItems_PMSchedDetails
(
	OrgId int NOT NULL,
	Id int NOT NULL IDENTITY (1, 1),
	InspectItemId int NOT NULL,
	PMSchedDetailId int NOT NULL,
	CONSTRAINT [PK_InspectionItems_PMSchedDetails] PRIMARY KEY CLUSTERED 
	(
		[Id],
		OrgId
	) ON [PRIMARY],
	CONSTRAINT [FK_InspectionItems_PMSchedDetails_InspectionItems] FOREIGN KEY
	(
		OrgId,
		InspectItemId
	) REFERENCES dbo.InspectionItems
	(
		OrgId,
		[Id]
	),
	CONSTRAINT [FK_InspectionItems_PMSchedDetails_PMSchedDetails] FOREIGN KEY
	(
		PMSchedDetailId,
		OrgId
	) REFERENCES dbo.PMSchedDetails
	(
		[Id],
		OrgId
	)
)  ON [PRIMARY]
GO
COMMIT

