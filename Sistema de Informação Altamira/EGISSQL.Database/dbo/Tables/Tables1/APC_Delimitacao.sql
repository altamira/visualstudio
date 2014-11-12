CREATE TABLE [dbo].[APC_Delimitacao] (
    [cd_controle]        INT          NOT NULL,
    [cd_assunto]         INT          NOT NULL,
    [cd_unidade_negocio] INT          NOT NULL,
    [cd_projeto]         VARCHAR (30) NULL,
    [nm_projeto]         VARCHAR (40) NULL,
    [cd_dimensao]        INT          NULL,
    [cd_area_negocio]    INT          NOT NULL,
    [cd_unidade_empresa] INT          NULL,
    [cd_cliente]         INT          NULL,
    [nm_cliente_projeto] VARCHAR (50) NULL,
    [nm_obs_delimitacao] VARCHAR (60) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_APC_Delimitacao] PRIMARY KEY CLUSTERED ([cd_controle] ASC),
    CONSTRAINT [FK_APC_Delimitacao_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

