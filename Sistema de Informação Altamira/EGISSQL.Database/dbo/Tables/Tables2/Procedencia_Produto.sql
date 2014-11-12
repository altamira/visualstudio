CREATE TABLE [dbo].[Procedencia_Produto] (
    [cd_procedencia_produto] INT          NOT NULL,
    [nm_procedencia_produto] VARCHAR (30) NOT NULL,
    [sg_procedencia_produto] CHAR (10)    NOT NULL,
    [cd_digito_procedencia]  INT          NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Procedencia_Produto] PRIMARY KEY CLUSTERED ([cd_procedencia_produto] ASC) WITH (FILLFACTOR = 90)
);

