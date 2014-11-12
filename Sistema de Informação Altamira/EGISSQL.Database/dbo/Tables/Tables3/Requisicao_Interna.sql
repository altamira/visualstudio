CREATE TABLE [dbo].[Requisicao_Interna] (
    [cd_requisicao_interna]     INT          NOT NULL,
    [dt_requisicao_interna]     DATETIME     NULL,
    [dt_necessidade]            DATETIME     NULL,
    [cd_departamento]           INT          NULL,
    [cd_centro_custo]           INT          NULL,
    [cd_aplicacao_produto]      INT          NULL,
    [ds_requisicao_interna]     TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_usuario_requisicao]     INT          NULL,
    [dt_estoque_req_interna]    DATETIME     NULL,
    [nm_item_requisicao]        VARCHAR (40) NULL,
    [ic_maquina]                CHAR (1)     NULL,
    [cd_loja]                   INT          NULL,
    [ic_lib_estoque_requisicao] CHAR (1)     NULL,
    [dt_lib_estoque_requisicao] DATETIME     NULL,
    [cd_motivo_req_interna]     INT          NULL,
    [cd_guia_fracionamento]     INT          NULL,
    [cd_funcionario]            INT          NULL,
    [cd_status_requisicao]      INT          NULL,
    [cd_consulta]               INT          NULL,
    [cd_posicao_separacao]      VARCHAR (15) NULL,
    CONSTRAINT [PK_Requisicao_Interna] PRIMARY KEY CLUSTERED ([cd_requisicao_interna] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Interna_Loja] FOREIGN KEY ([cd_loja]) REFERENCES [dbo].[Loja] ([cd_loja])
);


GO
CREATE NONCLUSTERED INDEX [ix_dt_requisicao_interna]
    ON [dbo].[Requisicao_Interna]([dt_requisicao_interna] ASC) WITH (FILLFACTOR = 90);

