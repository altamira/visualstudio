CREATE TABLE [dbo].[Fase_Proposta] (
    [cd_fase_proposta]        INT          NOT NULL,
    [nm_fase_proposta]        VARCHAR (40) NULL,
    [sg_fase_proposta]        CHAR (10)    NULL,
    [ic_padrao_fase_proposta] CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Fase_Proposta] PRIMARY KEY CLUSTERED ([cd_fase_proposta] ASC) WITH (FILLFACTOR = 90)
);

