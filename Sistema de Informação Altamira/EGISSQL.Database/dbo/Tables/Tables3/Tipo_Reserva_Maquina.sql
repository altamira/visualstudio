CREATE TABLE [dbo].[Tipo_Reserva_Maquina] (
    [cd_tipo_reserva_maquina] INT          NOT NULL,
    [nm_tipo_reserva_maquina] VARCHAR (30) NOT NULL,
    [sg_tipo_reserva_maquina] CHAR (10)    NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [ic_cliente_tipo_reserva] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Reserva_Maquina] PRIMARY KEY CLUSTERED ([cd_tipo_reserva_maquina] ASC) WITH (FILLFACTOR = 90)
);

