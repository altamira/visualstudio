CREATE TABLE [dbo].[Assunto_Produto] (
    [cd_assunto_produto] INT          NOT NULL,
    [nm_assunto_produto] VARCHAR (40) NULL,
    [sg_assunto_produto] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Assunto_Produto] PRIMARY KEY CLUSTERED ([cd_assunto_produto] ASC) WITH (FILLFACTOR = 90)
);

