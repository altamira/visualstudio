CREATE TABLE [dbo].[Plano_Composicao] (
    [cd_plano]      INT          NOT NULL,
    [cd_item_plano] INT          NOT NULL,
    [nm_item_plano] VARCHAR (40) NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Plano_Composicao] PRIMARY KEY CLUSTERED ([cd_plano] ASC, [cd_item_plano] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Plano_Composicao_Plano] FOREIGN KEY ([cd_plano]) REFERENCES [dbo].[Plano] ([cd_plano])
);

