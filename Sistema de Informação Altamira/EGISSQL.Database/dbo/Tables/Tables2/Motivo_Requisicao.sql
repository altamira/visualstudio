CREATE TABLE [dbo].[Motivo_Requisicao] (
    [cd_motivo_requisicao]     INT          NOT NULL,
    [nm_motivo_requisicao]     VARCHAR (30) NULL,
    [sg_motivo_requisicao]     CHAR (10)    NULL,
    [nm_referencia_padrao]     VARCHAR (30) NULL,
    [ic_motivo_requisicao]     CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [sg_imp_motivo_requisicao] CHAR (2)     NULL,
    [cd_tipo_pedido]           INT          NULL,
    CONSTRAINT [PK_Motivo_Requisicao] PRIMARY KEY CLUSTERED ([cd_motivo_requisicao] ASC) WITH (FILLFACTOR = 90)
);

