CREATE TABLE [dbo].[Processo_Padrao_Embalagem] (
    [cd_processo_padrao]      INT        NOT NULL,
    [cd_tipo_embalagem]       INT        NOT NULL,
    [cd_produto_embalagem]    INT        NULL,
    [cd_produto]              INT        NULL,
    [vl_custo_proc_embalagem] FLOAT (53) NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Processo_Padrao_Embalagem] PRIMARY KEY CLUSTERED ([cd_processo_padrao] ASC, [cd_tipo_embalagem] ASC) WITH (FILLFACTOR = 90)
);

