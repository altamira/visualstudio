CREATE TABLE [dbo].[Ano] (
    [cd_ano]                 INT          NOT NULL,
    [nm_ano]                 VARCHAR (30) NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [ic_estatistica_bi_ano]  CHAR (1)     NULL,
    [ic_estatisticas_bi_ano] CHAR (1)     NULL,
    CONSTRAINT [PK_Ano] PRIMARY KEY CLUSTERED ([cd_ano] ASC) WITH (FILLFACTOR = 90)
);

