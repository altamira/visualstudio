CREATE TABLE [dbo].[Cenario_Producao] (
    [cd_cenario_producao]          INT          NOT NULL,
    [nm_cenario_produto]           VARCHAR (40) NULL,
    [nm_fantasia_cenario_producao] VARCHAR (15) NULL,
    [ic_ativo_cenario_producao]    CHAR (1)     NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    CONSTRAINT [PK_Cenario_Producao] PRIMARY KEY CLUSTERED ([cd_cenario_producao] ASC) WITH (FILLFACTOR = 90)
);

