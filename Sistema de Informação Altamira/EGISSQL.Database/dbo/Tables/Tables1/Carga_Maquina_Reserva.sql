CREATE TABLE [dbo].[Carga_Maquina_Reserva] (
    [cd_maquina]              INT          NOT NULL,
    [dt_inicio_res_carga_maq] DATETIME     NULL,
    [dt_final_res_carga_maq]  DATETIME     NULL,
    [cd_tipo_reserva_maquina] INT          NULL,
    [qt_hora_res_carga_maq]   FLOAT (53)   NULL,
    [ic_mapa_res_carga_maq]   CHAR (1)     NULL,
    [ic_baixa_res_carga_maq]  CHAR (1)     NULL,
    [cd_cliente]              INT          NULL,
    [nm_obs_res_carga_maq]    VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_item_res_carga_maq]   INT          NULL,
    [dt_baixa_res_carga_maq]  DATETIME     NULL,
    CONSTRAINT [FK_Carga_Maquina_Reserva_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente]),
    CONSTRAINT [FK_Carga_Maquina_Reserva_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina]),
    CONSTRAINT [FK_Carga_Maquina_Reserva_Tipo_Reserva_Maquina] FOREIGN KEY ([cd_tipo_reserva_maquina]) REFERENCES [dbo].[Tipo_Reserva_Maquina] ([cd_tipo_reserva_maquina])
);

