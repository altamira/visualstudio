CREATE TABLE [dbo].[Aviso_Ponto] (
    [cd_aviso_ponto]       INT          NOT NULL,
    [nm_aviso_ponto]       VARCHAR (40) NULL,
    [sg_aviso_ponto]       CHAR (10)    NULL,
    [ic_ativo_aviso_ponto] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Aviso_Ponto] PRIMARY KEY CLUSTERED ([cd_aviso_ponto] ASC) WITH (FILLFACTOR = 90)
);

