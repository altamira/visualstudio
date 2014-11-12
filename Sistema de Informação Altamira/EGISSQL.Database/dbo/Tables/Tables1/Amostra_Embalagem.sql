CREATE TABLE [dbo].[Amostra_Embalagem] (
    [cd_amostra]           INT      NOT NULL,
    [cd_tipo_embalagem]    INT      NOT NULL,
    [cd_produto_embalagem] INT      NOT NULL,
    [cd_amostra_produto]   INT      NOT NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Amostra_Embalagem] PRIMARY KEY CLUSTERED ([cd_amostra] ASC, [cd_tipo_embalagem] ASC, [cd_produto_embalagem] ASC, [cd_amostra_produto] ASC) WITH (FILLFACTOR = 90)
);

