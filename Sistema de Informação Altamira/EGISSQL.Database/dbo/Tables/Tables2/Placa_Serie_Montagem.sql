CREATE TABLE [dbo].[Placa_Serie_Montagem] (
    [cd_serie_produto] INT      NOT NULL,
    [cd_tipo_serie]    INT      NOT NULL,
    [cd_montagem]      CHAR (1) NOT NULL,
    [ic_montagem_g]    CHAR (1) NULL,
    [cd_usuario]       INT      NULL,
    [dt_usuario]       DATETIME NULL,
    [cd_placa]         INT      NULL,
    [cd_tipo_montagem] INT      NULL,
    CONSTRAINT [PK_Placa_Serie_Montagem] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_tipo_serie] ASC, [cd_montagem] ASC) WITH (FILLFACTOR = 90)
);

