CREATE TABLE [dbo].[Requisicao_Compra_Aprovacao] (
    [cd_requisicao_compra]     INT          NOT NULL,
    [cd_item_aprov_requisicao] INT          NOT NULL,
    [cd_tipo_aprovacao]        INT          NULL,
    [ic_tipo_aprovacao]        CHAR (1)     NULL,
    [cd_usuario_aprovacao]     INT          NULL,
    [dt_usuario_aprovacao]     DATETIME     NULL,
    [dt_usuario_reprovacao]    DATETIME     NULL,
    [nm_obs_usu_reprovacao]    VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_obs_usu_aprovacao]     VARCHAR (40) NULL,
    CONSTRAINT [PK_Requisicao_Compra_Aprovacao] PRIMARY KEY CLUSTERED ([cd_requisicao_compra] ASC, [cd_item_aprov_requisicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Compra_Aprovacao_Tipo_Atendimento] FOREIGN KEY ([cd_tipo_aprovacao]) REFERENCES [dbo].[Tipo_Atendimento] ([cd_tipo_atendimento])
);

