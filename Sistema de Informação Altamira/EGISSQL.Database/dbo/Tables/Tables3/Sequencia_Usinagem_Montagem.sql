CREATE TABLE [dbo].[Sequencia_Usinagem_Montagem] (
    [cd_maquina]            INT      NOT NULL,
    [cd_magazine]           INT      NOT NULL,
    [cd_sequencia_usinagem] INT      NOT NULL,
    [cd_placa]              INT      NOT NULL,
    [cd_montagem]           INT      NOT NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    [cd_item]               INT      NULL,
    [cd_tipo_montagem]      INT      NULL,
    [cd_tipo_serie_produto] INT      NULL,
    CONSTRAINT [PK_Sequencia_Usinagem_Montagem] PRIMARY KEY CLUSTERED ([cd_maquina] ASC, [cd_magazine] ASC, [cd_sequencia_usinagem] ASC, [cd_placa] ASC, [cd_montagem] ASC) WITH (FILLFACTOR = 90)
);

