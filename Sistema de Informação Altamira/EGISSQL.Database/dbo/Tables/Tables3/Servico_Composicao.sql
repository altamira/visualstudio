CREATE TABLE [dbo].[Servico_Composicao] (
    [cd_servico]            INT          NOT NULL,
    [cd_item_servico]       INT          NOT NULL,
    [nm_servico_composicao] VARCHAR (90) NULL,
    [ds_servico_composicao] TEXT         NULL,
    [ic_ativo_servico]      CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Servico_Composicao] PRIMARY KEY CLUSTERED ([cd_servico] ASC, [cd_item_servico] ASC)
);

