CREATE TABLE [dbo].[Taxista] (
    [cd_taxista] INT          NOT NULL,
    [nm_taxista] VARCHAR (40) NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Taxista] PRIMARY KEY CLUSTERED ([cd_taxista] ASC) WITH (FILLFACTOR = 90)
);

