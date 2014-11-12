CREATE TABLE [dbo].[Centro_Receita_Composicao] (
    [cd_centro_receita]      INT          NOT NULL,
    [cd_item_centro_receita] INT          NOT NULL,
    [cd_departamento]        INT          NULL,
    [pc_centro_receita]      FLOAT (53)   NULL,
    [cd_plano_financeiro]    INT          NULL,
    [cd_lancamento_padrao]   INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [nm_item_centro_receita] VARCHAR (40) NULL,
    CONSTRAINT [PK_Centro_Receita_Composicao] PRIMARY KEY CLUSTERED ([cd_centro_receita] ASC, [cd_item_centro_receita] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Centro_Receita_Composicao_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

