CREATE TABLE [dbo].[Legenda] (
    [cd_legenda]       INT          NOT NULL,
    [nm_legenda]       VARCHAR (40) NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    [ic_ativo_legenda] CHAR (1)     NULL,
    [nm_cor_legenda]   VARCHAR (30) NULL,
    CONSTRAINT [PK_Legenda] PRIMARY KEY CLUSTERED ([cd_legenda] ASC) WITH (FILLFACTOR = 90)
);

