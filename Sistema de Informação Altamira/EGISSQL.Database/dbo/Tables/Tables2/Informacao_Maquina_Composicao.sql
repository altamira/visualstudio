CREATE TABLE [dbo].[Informacao_Maquina_Composicao] (
    [cd_informacao_maquina]  INT          NOT NULL,
    [cd_item_inf_maquina]    INT          NOT NULL,
    [nm_maquina]             VARCHAR (40) NULL,
    [vl_potencial_maquina]   FLOAT (53)   NULL,
    [qt_produzido_maquina]   FLOAT (53)   NULL,
    [vl_potencial_nosso_maq] FLOAT (53)   NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Informacao_Maquina_Composicao] PRIMARY KEY CLUSTERED ([cd_informacao_maquina] ASC, [cd_item_inf_maquina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Informacao_Maquina_Composicao_Informacao_Maquina] FOREIGN KEY ([cd_informacao_maquina]) REFERENCES [dbo].[Informacao_Maquina] ([cd_informacao_maquina])
);

