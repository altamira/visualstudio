CREATE TABLE [dbo].[Tipo_Producao] (
    [cd_tipo_producao] INT          NOT NULL,
    [nm_tipo_producao] VARCHAR (40) NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Producao] PRIMARY KEY CLUSTERED ([cd_tipo_producao] ASC) WITH (FILLFACTOR = 90)
);

