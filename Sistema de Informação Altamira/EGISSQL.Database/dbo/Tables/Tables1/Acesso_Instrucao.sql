CREATE TABLE [dbo].[Acesso_Instrucao] (
    [cd_acesso_instrucao] INT          NOT NULL,
    [nm_acesso_instrucao] VARCHAR (40) NULL,
    [sg_acesso_instrucao] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Acesso_Instrucao] PRIMARY KEY CLUSTERED ([cd_acesso_instrucao] ASC) WITH (FILLFACTOR = 90)
);

