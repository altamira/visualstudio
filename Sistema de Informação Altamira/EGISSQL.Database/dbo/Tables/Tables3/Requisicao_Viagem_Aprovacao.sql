CREATE TABLE [dbo].[Requisicao_Viagem_Aprovacao] (
    [cd_requisicao_viagem]    INT          NOT NULL,
    [cd_item_aprovacao]       INT          NOT NULL,
    [cd_usuario_aprovacao]    INT          NULL,
    [dt_aprovacao_req_viagem] DATETIME     NOT NULL,
    [nm_obs_aprovacao]        VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_tipo_aprovacao]       INT          NULL,
    [ic_aprovado]             CHAR (1)     NULL,
    [cd_funcionario]          INT          NULL,
    CONSTRAINT [PK_Requisicao_Viagem_Aprovacao] PRIMARY KEY CLUSTERED ([cd_requisicao_viagem] ASC, [cd_item_aprovacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Viagem_Aprovacao_Tipo_Aprovacao] FOREIGN KEY ([cd_tipo_aprovacao]) REFERENCES [dbo].[Tipo_Aprovacao] ([cd_tipo_aprovacao])
);

