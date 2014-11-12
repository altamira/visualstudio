CREATE TABLE [dbo].[Montagem_Plano_Especial] (
    [cd_empresa]             INT      NOT NULL,
    [cd_plano_padrao]        INT      NOT NULL,
    [cd_plano_especial]      INT      NOT NULL,
    [cd_item_plano_especial] INT      NOT NULL,
    [cd_conta]               INT      NOT NULL,
    [cd_usuario]             INT      NOT NULL,
    [dt_usuario]             DATETIME NOT NULL,
    CONSTRAINT [PK_Montagem_plano_especial] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_plano_padrao] ASC, [cd_plano_especial] ASC, [cd_item_plano_especial] ASC) WITH (FILLFACTOR = 90)
);

