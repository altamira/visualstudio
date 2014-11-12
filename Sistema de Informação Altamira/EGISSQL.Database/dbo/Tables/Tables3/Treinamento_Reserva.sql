CREATE TABLE [dbo].[Treinamento_Reserva] (
    [cd_treinamento_reserva]     INT          NOT NULL,
    [dt_treinamento_reserva]     DATETIME     NULL,
    [cd_funcionario]             INT          NULL,
    [cd_curso]                   INT          NULL,
    [nm_obs_treinamento_reserva] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Treinamento_Reserva] PRIMARY KEY CLUSTERED ([cd_treinamento_reserva] ASC) WITH (FILLFACTOR = 90)
);

