CREATE TABLE [dbo].[Consulta_Item_Orcamento_Servico_Manual] (
    [cd_consulta]               INT          NOT NULL,
    [cd_item_consulta]          INT          NOT NULL,
    [cd_item_orcamento]         INT          NOT NULL,
    [cd_item_serv_manual]       INT          NOT NULL,
    [qt_hora_item_serv_manual]  FLOAT (53)   NULL,
    [vl_unit_item_serv_manual]  FLOAT (53)   NULL,
    [vl_total_item_serv_manual] FLOAT (53)   NULL,
    [nm_item_servico_manual]    VARCHAR (40) NULL,
    [cd_tipo_mao_obra]          INT          NULL,
    [ic_tipo_mao_obra]          CHAR (1)     NULL,
    [ic_markup_serv_manual]     CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_mao_obra]               INT          NULL,
    [cd_categoria_orcamento]    INT          NULL,
    CONSTRAINT [PK_Consulta_Item_Orcamento_Servico_Manual] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_item_orcamento] ASC, [cd_item_serv_manual] ASC) WITH (FILLFACTOR = 90)
);

