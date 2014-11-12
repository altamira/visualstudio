CREATE TABLE [dbo].[Maquina_Operador] (
    [cd_maquina]                INT          NOT NULL,
    [cd_operador]               INT          NOT NULL,
    [cd_turno]                  INT          NULL,
    [nm_obs_maquina_operador]   VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_ativo_maquina_operador] CHAR (1)     NULL,
    CONSTRAINT [PK_Maquina_Operador] PRIMARY KEY CLUSTERED ([cd_maquina] ASC, [cd_operador] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Maquina_Operador_Turno] FOREIGN KEY ([cd_turno]) REFERENCES [dbo].[Turno] ([cd_turno])
);

