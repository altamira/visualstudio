CREATE TABLE [dbo].[Requisicao_Viagem_Aprovador] (
    [cd_requisicao_viagem] INT      NOT NULL,
    [cd_item_aprovador]    INT      NOT NULL,
    [cd_funcionario]       INT      NULL,
    [cd_tipo_aprovacao]    INT      NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Requisicao_Viagem_Aprovador] PRIMARY KEY CLUSTERED ([cd_requisicao_viagem] ASC, [cd_item_aprovador] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Viagem_Aprovador_Requisicao_Viagem] FOREIGN KEY ([cd_requisicao_viagem]) REFERENCES [dbo].[Requisicao_Viagem] ([cd_requisicao_viagem])
);

