CREATE TABLE [dbo].[Tipo_Parcela] (
    [cd_tipo_parcela] INT          NOT NULL,
    [nm_tipo_parcela] VARCHAR (20) NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Parcela] PRIMARY KEY CLUSTERED ([cd_tipo_parcela] ASC) WITH (FILLFACTOR = 90)
);

