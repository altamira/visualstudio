CREATE TABLE [dbo].[Placa_Montagem_Usinagem] (
    [cd_serie_produto] INT      NOT NULL,
    [cd_tipo_serie]    INT      NOT NULL,
    [cd_item_montagem] INT      NOT NULL,
    [cd_placa]         INT      NULL,
    [ic_estrutura]     CHAR (1) NULL,
    [cd_usuario]       INT      NULL,
    [dt_usuario]       DATETIME NULL,
    CONSTRAINT [PK_Placa_Montagem_Usinagem] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_tipo_serie] ASC, [cd_item_montagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Placa_Montagem_Usinagem_Placa] FOREIGN KEY ([cd_placa]) REFERENCES [dbo].[Placa] ([cd_placa])
);

