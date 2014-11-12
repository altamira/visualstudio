CREATE TABLE [dbo].[Cadeia_Valor] (
    [cd_cadeia_valor]              INT          NOT NULL,
    [nm_cadeia_valor]              VARCHAR (40) NULL,
    [sg_cadeia_valor]              CHAR (10)    NULL,
    [ic_cadeia_valor_liberada]     CHAR (1)     NULL,
    [nm_imagem_cadeia_valor]       VARCHAR (40) NULL,
    [ds_cadeia_valor]              TEXT         NULL,
    [cd_imagem]                    INT          NULL,
    [cd_help]                      INT          NULL,
    [nm_executavel]                VARCHAR (70) NULL,
    [cd_ordem_cadeia_valor]        INT          NULL,
    [nm_local_origem_cadeia_valor] VARCHAR (70) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [ic_alteracao]                 CHAR (1)     NULL,
    [nm_local_cadeia_valor]        VARCHAR (70) NULL,
    CONSTRAINT [PK_Cadeia_Valor] PRIMARY KEY CLUSTERED ([cd_cadeia_valor] ASC) WITH (FILLFACTOR = 90)
);

