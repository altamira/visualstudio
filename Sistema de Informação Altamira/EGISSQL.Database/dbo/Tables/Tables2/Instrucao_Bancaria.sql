CREATE TABLE [dbo].[Instrucao_Bancaria] (
    [cd_instrucao]          INT          NOT NULL,
    [nm_instrucao]          VARCHAR (80) NULL,
    [sg_instrucao]          CHAR (10)    NULL,
    [ds_instrucao]          TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_atualiza_documento] CHAR (1)     NULL
);

