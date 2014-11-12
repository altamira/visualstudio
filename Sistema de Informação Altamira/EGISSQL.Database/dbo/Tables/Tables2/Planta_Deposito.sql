CREATE TABLE [dbo].[Planta_Deposito] (
    [cd_planta]              INT          NOT NULL,
    [cd_deposito]            INT          NULL,
    [cd_fase_produto]        INT          NOT NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [nm_obs_planta_deposito] VARCHAR (40) NULL,
    CONSTRAINT [PK_Planta_Deposito] PRIMARY KEY CLUSTERED ([cd_planta] ASC, [cd_fase_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Planta_Deposito_Fase_Produto] FOREIGN KEY ([cd_fase_produto]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto])
);

