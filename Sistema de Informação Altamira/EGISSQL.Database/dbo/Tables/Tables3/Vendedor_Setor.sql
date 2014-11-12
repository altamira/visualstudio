CREATE TABLE [dbo].[Vendedor_Setor] (
    [cd_vendedor]               INT          NOT NULL,
    [cd_vendedor_setor]         INT          NOT NULL,
    [nm_vendedor_setor]         VARCHAR (40) NULL,
    [nm_fantasia_setor_vend]    VARCHAR (15) NULL,
    [pc_comissao_setor_vend]    FLOAT (53)   NULL,
    [cd_banco]                  INT          NULL,
    [nm_agencia_vendedor_setor] VARCHAR (20) NULL,
    [nm_conta_vendedor_setor]   VARCHAR (20) NULL,
    [nm_obs_vendedor_setor]     VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Vendedor_Setor] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [cd_vendedor_setor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Vendedor_Setor_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco])
);

