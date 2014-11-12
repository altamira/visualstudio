CREATE TABLE [dbo].[Cliente_Assunto] (
    [cd_cliente_assunto] INT          NOT NULL,
    [nm_cliente_assunto] VARCHAR (30) NULL,
    [sg_cliente_assunto] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Assunto] PRIMARY KEY CLUSTERED ([cd_cliente_assunto] ASC) WITH (FILLFACTOR = 90)
);

