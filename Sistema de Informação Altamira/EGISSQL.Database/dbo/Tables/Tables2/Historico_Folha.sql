CREATE TABLE [dbo].[Historico_Folha] (
    [cd_historico_folha] INT          NOT NULL,
    [nm_historico_folha] VARCHAR (40) NOT NULL,
    [sg_historico_folha] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Historico_Folha] PRIMARY KEY CLUSTERED ([cd_historico_folha] ASC) WITH (FILLFACTOR = 90)
);

