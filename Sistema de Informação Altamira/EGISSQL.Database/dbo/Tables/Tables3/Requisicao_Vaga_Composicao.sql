CREATE TABLE [dbo].[Requisicao_Vaga_Composicao] (
    [cd_requisicao_vaga]       INT        NOT NULL,
    [cd_item_requisicao_vaga]  INT        NOT NULL,
    [cd_cargo]                 INT        NULL,
    [ds_perfil_vaga]           TEXT       NULL,
    [vl_salario_vaga]          FLOAT (53) NULL,
    [cd_seccao]                INT        NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [cd_cargo_funcionario]     INT        NULL,
    [dt_baixa_item_requisicao] DATETIME   NULL,
    [qt_item_requisicao]       FLOAT (53) NULL,
    [vl_total_item_requisicao] FLOAT (53) NULL,
    CONSTRAINT [PK_Requisicao_Vaga_Composicao] PRIMARY KEY CLUSTERED ([cd_requisicao_vaga] ASC, [cd_item_requisicao_vaga] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Vaga_Composicao_Cargo_Funcionario] FOREIGN KEY ([cd_cargo_funcionario]) REFERENCES [dbo].[Cargo_Funcionario] ([cd_cargo_funcionario]),
    CONSTRAINT [FK_Requisicao_Vaga_Composicao_Seccao] FOREIGN KEY ([cd_seccao]) REFERENCES [dbo].[Seccao] ([cd_seccao])
);

