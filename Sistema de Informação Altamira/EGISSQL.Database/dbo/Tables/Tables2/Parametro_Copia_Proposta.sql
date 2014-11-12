CREATE TABLE [dbo].[Parametro_Copia_Proposta] (
    [cd_empresa]                   INT      NOT NULL,
    [ic_zera_preco_venda_especial] CHAR (1) NULL,
    [cd_usuario]                   INT      NULL,
    [dt_usuario]                   DATETIME NULL,
    CONSTRAINT [PK_Parametro_Copia_Proposta] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

