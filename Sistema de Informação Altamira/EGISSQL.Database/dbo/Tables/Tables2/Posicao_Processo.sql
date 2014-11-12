CREATE TABLE [dbo].[Posicao_Processo] (
    [cd_posicao_processo] INT          NOT NULL,
    [nm_posicao_processo] VARCHAR (40) NULL,
    [sg_posicao_processo] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Posicao_Processo] PRIMARY KEY CLUSTERED ([cd_posicao_processo] ASC) WITH (FILLFACTOR = 90)
);

