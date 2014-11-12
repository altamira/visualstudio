CREATE TABLE [dbo].[Situacao_Evento] (
    [cd_situacao_evento] INT          NOT NULL,
    [nm_situacao_evento] VARCHAR (20) NOT NULL,
    [ds_situacao_evento] TEXT         NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Situacao_Evento] PRIMARY KEY CLUSTERED ([cd_situacao_evento] ASC) WITH (FILLFACTOR = 90)
);

