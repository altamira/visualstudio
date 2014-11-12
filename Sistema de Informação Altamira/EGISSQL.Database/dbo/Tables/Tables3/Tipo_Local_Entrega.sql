CREATE TABLE [dbo].[Tipo_Local_Entrega] (
    [cd_tipo_local_entrega]      INT          NOT NULL,
    [nm_tipo_local_entrega]      VARCHAR (30) NOT NULL,
    [sg_tipo_local_entrega]      VARCHAR (10) NOT NULL,
    [cd_usuario]                 INT          NOT NULL,
    [dt_usuario]                 DATETIME     NOT NULL,
    [ic_aviso_local_entrega]     CHAR (1)     NULL,
    [ic_padrao_local_entrega]    CHAR (1)     NULL,
    [ic_nf_tipo_local_entrega]   CHAR (1)     NULL,
    [ic_end_tipo_local_entrega]  CHAR (1)     NULL,
    [ic_selecao_movimento_caixa] CHAR (1)     NULL,
    [ic_transportadora_entrega]  CHAR (1)     NULL,
    [ic_pad_movimento_caixa]     CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Local_Entrega] PRIMARY KEY CLUSTERED ([cd_tipo_local_entrega] ASC) WITH (FILLFACTOR = 90)
);

