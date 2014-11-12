CREATE TABLE [dbo].[Banco_Assunto] (
    [cd_banco_assunto] INT          NOT NULL,
    [nm_banco_assunto] VARCHAR (40) NULL,
    [sg_banco_assunto] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Banco_Assunto] PRIMARY KEY CLUSTERED ([cd_banco_assunto] ASC) WITH (FILLFACTOR = 90)
);

