CREATE TABLE [dbo].[Operador_Valor] (
    [cd_operador]         INT          NOT NULL,
    [dt_inicial_operador] DATETIME     NOT NULL,
    [dt_final_operador]   DATETIME     NOT NULL,
    [vl_operador]         FLOAT (53)   NULL,
    [vl_encargo_operador] FLOAT (53)   NULL,
    [nm_obs_operador]     VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [cd_aplicacao_markup] INT          NULL,
    CONSTRAINT [PK_Operador_Valor] PRIMARY KEY CLUSTERED ([cd_operador] ASC, [dt_inicial_operador] ASC, [dt_final_operador] ASC) WITH (FILLFACTOR = 90)
);

