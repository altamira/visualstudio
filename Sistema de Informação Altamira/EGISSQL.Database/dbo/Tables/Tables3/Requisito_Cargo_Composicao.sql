CREATE TABLE [dbo].[Requisito_Cargo_Composicao] (
    [cd_cargo_funcionario]    INT          NOT NULL,
    [cd_requisito_cargo]      INT          NOT NULL,
    [cd_item_requisito_cargo] INT          NOT NULL,
    [nm_item_requisito_cargo] VARCHAR (60) NULL,
    [ds_item_requisito_cargo] TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Requisito_Cargo_Composicao] PRIMARY KEY CLUSTERED ([cd_cargo_funcionario] ASC, [cd_requisito_cargo] ASC, [cd_item_requisito_cargo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisito_Cargo_Composicao_Requisito_Cargo] FOREIGN KEY ([cd_requisito_cargo]) REFERENCES [dbo].[Requisito_Cargo] ([cd_requisito_cargo])
);

