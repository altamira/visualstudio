CREATE TABLE [dbo].[Cliente_Imposto_Estado] (
    [cd_cliente_imposto]         INT          NOT NULL,
    [cd_cliente]                 INT          NOT NULL,
    [cd_estado]                  INT          NOT NULL,
    [cd_pais]                    INT          NOT NULL,
    [cd_imposto]                 INT          NULL,
    [cd_dispositivo_legal]       INT          NULL,
    [pc_imposto_cliente]         FLOAT (53)   NULL,
    [pc_reducao_imposto_cliente] FLOAT (53)   NULL,
    [nm_obs_cliente_imposto]     VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_operacao_fiscal]         INT          NULL,
    CONSTRAINT [PK_Cliente_Imposto_Estado] PRIMARY KEY CLUSTERED ([cd_cliente_imposto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Imposto_Estado_Dispositivo_Legal] FOREIGN KEY ([cd_dispositivo_legal]) REFERENCES [dbo].[Dispositivo_Legal] ([cd_dispositivo_legal]),
    CONSTRAINT [FK_Cliente_Imposto_Estado_Operacao_Fiscal] FOREIGN KEY ([cd_operacao_fiscal]) REFERENCES [dbo].[Operacao_Fiscal] ([cd_operacao_fiscal])
);

