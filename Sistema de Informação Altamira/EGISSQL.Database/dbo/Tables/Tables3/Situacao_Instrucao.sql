CREATE TABLE [dbo].[Situacao_Instrucao] (
    [cd_situacao_instrucao] INT          NOT NULL,
    [nm_situacao_instrucao] VARCHAR (40) NULL,
    [sg_situacao_instrucao] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Situacao_Instrucao] PRIMARY KEY CLUSTERED ([cd_situacao_instrucao] ASC) WITH (FILLFACTOR = 90)
);

