CREATE TABLE [dbo].[Cliente_Qualidade] (
    [cd_cliente]               INT          NOT NULL,
    [ic_dimensional_cliente]   CHAR (1)     NULL,
    [ic_quimico_cliente]       CHAR (1)     NULL,
    [ic_balanceamento_cliente] CHAR (1)     NULL,
    [nm_obs_cliente_qualidade] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Qualidade] PRIMARY KEY CLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Qualidade_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

