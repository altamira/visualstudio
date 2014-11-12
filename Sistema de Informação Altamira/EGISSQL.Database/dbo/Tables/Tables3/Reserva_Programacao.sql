CREATE TABLE [dbo].[Reserva_Programacao] (
    [cd_reserva_programacao]  INT          NOT NULL,
    [dt_reserva_programacao]  DATETIME     NULL,
    [cd_maquina]              INT          NULL,
    [qt_hora_reserva_prog]    FLOAT (53)   NULL,
    [cd_tipo_reserva_maquina] INT          NULL,
    [cd_cliente]              INT          NULL,
    [ds_reserva_programacao]  TEXT         NULL,
    [nm_obs_reserva_prog]     VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [dt_final_reserva_prog]   DATETIME     NULL,
    [dt_inicio_reserva_prog]  DATETIME     NULL,
    [cd_projeto_material]     INT          NULL,
    [cd_item_projeto]         INT          NULL,
    [cd_projeto]              INT          NULL,
    CONSTRAINT [PK_Reserva_Programacao] PRIMARY KEY CLUSTERED ([cd_reserva_programacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Reserva_Programacao_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

