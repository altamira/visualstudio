CREATE TABLE [dbo].[Produto_Conversao] (
    [cd_conversao]             INT          NOT NULL,
    [dt_conversao]             DATETIME     NULL,
    [cd_produto]               INT          NULL,
    [cd_produto_conversao]     INT          NULL,
    [ic_produto_conversao]     CHAR (1)     NULL,
    [ic_exclusao_conversao]    CHAR (1)     NULL,
    [nm_obs_produto_conversao] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Produto_Conversao] PRIMARY KEY CLUSTERED ([cd_conversao] ASC) WITH (FILLFACTOR = 90)
);

