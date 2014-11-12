CREATE TABLE [dbo].[Conf_Prog_CNC] (
    [cd_serie_produto]      INT      NULL,
    [cd_tipo_serie_produto] INT      NULL,
    [cd_sub_serie_produto]  INT      NULL,
    [cd_placa]              INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [FK_Conf_Prog_CNC_Placa] FOREIGN KEY ([cd_placa]) REFERENCES [dbo].[Placa] ([cd_placa]),
    CONSTRAINT [FK_Conf_Prog_CNC_Tipo_Serie_Produto] FOREIGN KEY ([cd_tipo_serie_produto]) REFERENCES [dbo].[Tipo_Serie_Produto] ([cd_tipo_serie_produto])
);

