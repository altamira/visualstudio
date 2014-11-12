CREATE TABLE [dbo].[Modelo_Recibo] (
    [cd_modelo_recibo]        INT          NOT NULL,
    [nm_modelo_recibo]        VARCHAR (40) NULL,
    [sg_modelo_recibo]        CHAR (10)    NULL,
    [ic_padrao_modelo_recibo] CHAR (1)     NULL,
    [ic_modelo_recibo]        CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [qt_tamanho_linha]        INT          NULL,
    [qt_tamanho_coluna]       INT          NULL,
    CONSTRAINT [PK_Modelo_Recibo] PRIMARY KEY CLUSTERED ([cd_modelo_recibo] ASC) WITH (FILLFACTOR = 90)
);

