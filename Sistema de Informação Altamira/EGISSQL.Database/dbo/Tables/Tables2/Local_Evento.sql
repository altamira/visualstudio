CREATE TABLE [dbo].[Local_Evento] (
    [cd_contrato]              INT          NOT NULL,
    [cd_evento]                INT          NOT NULL,
    [cd_grupo_local_cemiterio] INT          NOT NULL,
    [nm_local_evento]          VARCHAR (15) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Local_Evento] PRIMARY KEY CLUSTERED ([cd_contrato] ASC, [cd_evento] ASC, [cd_grupo_local_cemiterio] ASC) WITH (FILLFACTOR = 90)
);

