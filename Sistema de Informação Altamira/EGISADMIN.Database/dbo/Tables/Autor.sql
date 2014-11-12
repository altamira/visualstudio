CREATE TABLE [dbo].[Autor] (
    [cd_autor]          INT           NOT NULL,
    [nm_autor]          VARCHAR (40)  NOT NULL,
    [nm_fantasia_autor] VARCHAR (15)  NOT NULL,
    [cd_celular_autor]  VARCHAR (15)  NOT NULL,
    [nm_email_autor]    VARCHAR (100) NOT NULL,
    [ic_ativo_autor]    CHAR (1)      NOT NULL,
    [cd_usuario]        INT           NOT NULL,
    [dt_usuario]        DATETIME      NOT NULL,
    CONSTRAINT [PK_Autor] PRIMARY KEY CLUSTERED ([cd_autor] ASC) WITH (FILLFACTOR = 90)
);

