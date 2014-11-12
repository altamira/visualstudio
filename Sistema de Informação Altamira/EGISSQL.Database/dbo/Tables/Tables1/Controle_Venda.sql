CREATE TABLE [dbo].[Controle_Venda] (
    [cd_controle_venda]          INT      NOT NULL,
    [cd_registro_controle_venda] INT      NULL,
    [cd_codigo_barra_controle]   INT      NOT NULL,
    [ic_status_controle]         CHAR (1) NULL,
    [cd_usuario]                 INT      NULL,
    [dt_usuario]                 DATETIME NULL,
    [cd_loja]                    INT      NULL,
    CONSTRAINT [PK_Controle_Venda] PRIMARY KEY CLUSTERED ([cd_controle_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Controle_Venda_Loja] FOREIGN KEY ([cd_loja]) REFERENCES [dbo].[Loja] ([cd_loja])
);

