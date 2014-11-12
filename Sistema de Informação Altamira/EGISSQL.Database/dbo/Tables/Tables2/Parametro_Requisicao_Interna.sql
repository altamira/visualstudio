CREATE TABLE [dbo].[Parametro_Requisicao_Interna] (
    [dt_usuario]               DATETIME NULL,
    [cd_usuario]               INT      NULL,
    [ic_req_aprovacao_empresa] CHAR (1) NULL,
    [ds_req_mensagem_empresa]  TEXT     NULL,
    [ic_req_endereco_empresa]  CHAR (1) NULL,
    [ic_req_logotipo_empresa]  CHAR (1) NULL,
    [cd_empresa]               INT      NOT NULL,
    CONSTRAINT [PK_Parametro_Requisicao_Interna] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

