CREATE TABLE [dbo].[Categoria_Desconto_Comissao] (
    [cd_categoria_produto]      INT          NOT NULL,
    [cd_tipo_desconto_comissao] INT          NOT NULL,
    [cd_desconto_comissao]      INT          NOT NULL,
    [nm_desconto_comissao]      VARCHAR (40) NULL,
    [sg_desconto_comissao]      CHAR (10)    NULL,
    [pc_comissao_desc_comissao] FLOAT (53)   NULL,
    [pc_ini_desconto_comissao]  FLOAT (53)   NULL,
    [pc_fim_desconto_comissao]  FLOAT (53)   NULL,
    [nm_obs_desconto_comissao]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Categoria_Desconto_Comissao] PRIMARY KEY CLUSTERED ([cd_categoria_produto] ASC, [cd_tipo_desconto_comissao] ASC, [cd_desconto_comissao] ASC) WITH (FILLFACTOR = 90)
);

