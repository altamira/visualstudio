CREATE TABLE [dbo].[NFE] (
    [cd_nfe]               INT      NOT NULL,
    [cd_nota_saida]        INT      NULL,
    [cd_serie_nota_fiscal] INT      NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_NFE] PRIMARY KEY CLUSTERED ([cd_nfe] ASC) WITH (FILLFACTOR = 90)
);

