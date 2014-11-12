CREATE TABLE [dbo].[Regiao_Venda_Composicao] (
    [cd_regiao_venda]      INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_item_regiao_venda] INT          NULL,
    [ds_regiao_composicao] TEXT         NULL,
    [ic_ativo_regiao]      CHAR (1)     NULL,
    [sg_regiao_composicao] CHAR (10)    NULL,
    [nm_regiao_composicao] VARCHAR (40) NULL,
    [cd_mascara_regiao]    VARCHAR (20) NULL
);

