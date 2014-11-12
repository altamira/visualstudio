CREATE TABLE [dbo].[Grau_Instrucao] (
    [cd_grau_instrucao]       INT          NOT NULL,
    [nm_grau_instrucao]       VARCHAR (30) NULL,
    [sg_grau_instrucao]       CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ds_grau_instrucao]       TEXT         NULL,
    [cd_cadeg_grau_instrucao] CHAR (3)     NULL,
    CONSTRAINT [PK_Grau_Instrucao] PRIMARY KEY CLUSTERED ([cd_grau_instrucao] ASC) WITH (FILLFACTOR = 90)
);

