CREATE TABLE [dbo].[Requisicao_Viagem_Liberacao] (
    [cd_requisicao_viagem]    INT          NOT NULL,
    [cd_item_liberacao]       INT          NOT NULL,
    [cd_funcionario]          INT          NULL,
    [dt_liberacao_requisicao] DATETIME     NULL,
    [nm_obs_liberacao]        VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Requisicao_Viagem_Liberacao] PRIMARY KEY CLUSTERED ([cd_requisicao_viagem] ASC, [cd_item_liberacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Viagem_Liberacao_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

