CREATE TABLE [dbo].[Requisicao_Fabricacao] (
    [cd_requisicao]                 INT          NOT NULL,
    [dt_requisicao]                 DATETIME     NULL,
    [cd_motivo_requisicao]          INT          NULL,
    [cd_usuario_requisicao]         INT          NULL,
    [cd_departamento]               INT          NULL,
    [cd_centro_custo]               INT          NULL,
    [cd_aplicacao_produto]          INT          NULL,
    [dt_necessidade]                DATETIME     NULL,
    [ic_liberada_requisicao]        CHAR (1)     NULL,
    [dt_liberacao_requisicao]       DATETIME     NULL,
    [ds_requisicao]                 TEXT         NULL,
    [dt_cancelamento_requisicao]    DATETIME     NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL,
    [cd_identificacao_requisicao]   VARCHAR (15) NULL,
    [dt_estoque_req_fabricacao]     DATETIME     NULL,
    [ic_lib_estoque_req_fabricacao] CHAR (1)     NULL,
    CONSTRAINT [PK_Requisicao_Fabricacao] PRIMARY KEY CLUSTERED ([cd_requisicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Fabricacao_Aplicacao_Produto] FOREIGN KEY ([cd_aplicacao_produto]) REFERENCES [dbo].[Aplicacao_Produto] ([cd_aplicacao_produto])
);

