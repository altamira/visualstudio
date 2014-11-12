CREATE TABLE [dbo].[Orcamento_Texto_Padrao] (
    [cd_produto_orcamento_cq]   CHAR (15)    NOT NULL,
    [cd_orcamento_texto_padrao] INT          NOT NULL,
    [ds_aplicacao_texto_padrao] TEXT         NULL,
    [ds_obs_texto_padrao]       TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [nm_texto_proposta]         VARCHAR (60) NULL,
    CONSTRAINT [PK_Orcamento_texto_padrao] PRIMARY KEY CLUSTERED ([cd_produto_orcamento_cq] ASC, [cd_orcamento_texto_padrao] ASC) WITH (FILLFACTOR = 90)
);

