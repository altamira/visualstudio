CREATE TABLE [dbo].[Cliente_Ponto] (
    [cd_ponto]                INT           NOT NULL,
    [cd_cliente]              INT           NOT NULL,
    [dt_cliente_ponto]        DATETIME      NULL,
    [nm_obs_cliente_ponto]    VARCHAR (40)  NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [ic_ativo_cliente_ponto]  CHAR (1)      NULL,
    [ds_cliente_ponto]        TEXT          NULL,
    [nm_imagem_cliente_ponto] VARCHAR (150) NULL,
    CONSTRAINT [PK_Cliente_Ponto] PRIMARY KEY CLUSTERED ([cd_ponto] ASC, [cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Ponto_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

