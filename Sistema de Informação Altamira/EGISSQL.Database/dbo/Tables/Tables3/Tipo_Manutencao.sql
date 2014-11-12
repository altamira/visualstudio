CREATE TABLE [dbo].[Tipo_Manutencao] (
    [cd_tipo_manutencao] INT          NOT NULL,
    [nm_tipo_manutencao] VARCHAR (40) NULL,
    [sg_tipo_manutencao] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Manutencao] PRIMARY KEY CLUSTERED ([cd_tipo_manutencao] ASC) WITH (FILLFACTOR = 90)
);

