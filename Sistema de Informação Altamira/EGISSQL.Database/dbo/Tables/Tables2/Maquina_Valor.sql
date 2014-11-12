CREATE TABLE [dbo].[Maquina_Valor] (
    [cd_maquina]         INT          NOT NULL,
    [dt_inicial_maquina] DATETIME     NOT NULL,
    [dt_final_maquina]   DATETIME     NOT NULL,
    [vl_hora_maquina]    FLOAT (53)   NULL,
    [mn_obs_maquina]     VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Maquina_Valor] PRIMARY KEY CLUSTERED ([cd_maquina] ASC, [dt_inicial_maquina] ASC, [dt_final_maquina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Maquina_Valor_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

