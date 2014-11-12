CREATE TABLE [dbo].[Status_Produto] (
    [cd_status_produto]        INT          NOT NULL,
    [nm_status_produto]        VARCHAR (30) NOT NULL,
    [sg_status_produto]        CHAR (10)    NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [ic_permitir_venda]        CHAR (1)     NULL,
    [ic_padrao_status_produto] CHAR (1)     NULL,
    [ic_bloqueia_uso_produto]  CHAR (1)     NULL,
    [ic_permite_exportacao]    CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Produto] PRIMARY KEY CLUSTERED ([cd_status_produto] ASC) WITH (FILLFACTOR = 90)
);

