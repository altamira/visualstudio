CREATE TABLE [dbo].[Processo_Padrao_Texto] (
    [cd_processo_padrao]        INT      NOT NULL,
    [cd_tipo_texto_processo]    INT      NOT NULL,
    [cd_composicao_proc_padrao] INT      NOT NULL,
    [ds_processo_padrao_texto]  TEXT     NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Processo_Padrao_Texto] PRIMARY KEY CLUSTERED ([cd_processo_padrao] ASC, [cd_tipo_texto_processo] ASC, [cd_composicao_proc_padrao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Padrao_Texto_Processo_Padrao_Composicao] FOREIGN KEY ([cd_processo_padrao], [cd_composicao_proc_padrao]) REFERENCES [dbo].[Processo_Padrao_Composicao] ([cd_processo_padrao], [cd_composicao_proc_padrao]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Processo_Padrao_Texto_Tipo_Texto_Processo] FOREIGN KEY ([cd_tipo_texto_processo]) REFERENCES [dbo].[Tipo_Texto_Processo] ([cd_tipo_texto_processo])
);

