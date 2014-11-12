CREATE TABLE [dbo].[Celula_Produtiva] (
    [cd_celula_produtiva] INT          NOT NULL,
    [nm_celula_produtiva] VARCHAR (30) NOT NULL,
    [sg_celula_produtiva] CHAR (10)    NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Celula_Produtiva] PRIMARY KEY CLUSTERED ([cd_celula_produtiva] ASC) WITH (FILLFACTOR = 90)
);

