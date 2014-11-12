CREATE TABLE [dbo].[Pedido_Importacao_Entreposto] (
    [cd_pedido_importacao]      INT          NOT NULL,
    [cd_terminal_carga]         INT          NOT NULL,
    [dt_entrepostagem]          DATETIME     NOT NULL,
    [nm_despadua_entrepostagem] VARCHAR (30) NOT NULL,
    [dt_despadua_entrepostagem] DATETIME     NOT NULL,
    [nm_docterm_entrepostagem]  VARCHAR (30) NOT NULL,
    [dt_docterm_entrepostagem]  DATETIME     NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Pedido_Importacao_Entreposto] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC, [cd_terminal_carga] ASC) WITH (FILLFACTOR = 90)
);

