CREATE TABLE [dbo].[Tipo_Cone] (
    [cd_tipo_cone] INT          NOT NULL,
    [nm_tipo_cone] VARCHAR (40) NULL,
    [sg_tipo_cone] VARCHAR (15) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]   INT          NOT NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK__Tipo_Cone__32AB8735] PRIMARY KEY CLUSTERED ([cd_tipo_cone] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [XIF3Tipo_Cone]
    ON [dbo].[Tipo_Cone]([cd_usuario] ASC) WITH (FILLFACTOR = 90);

