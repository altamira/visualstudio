CREATE TABLE [dbo].[Cliente_Fornecedor] (
    [cd_cliente]             INT          NOT NULL,
    [cd_cliente_fornecedor]  INT          NOT NULL,
    [nm_cliente_fornecedor]  VARCHAR (30) NOT NULL,
    [sg_cliente_fornecedor]  CHAR (10)    NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [ic_status_contato_forn] CHAR (1)     NULL
);

