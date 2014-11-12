CREATE TABLE [dbo].[Tipo_Pagamento_Comissao] (
    [cd_tipo_pag_comissao]     INT          NOT NULL,
    [nm_tipo_pag_comissao]     VARCHAR (40) NULL,
    [sg_tipo_pag_comissao]     CHAR (10)    NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [ic_pag_tipo_pag_comissao] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Pagamento_Comissao] PRIMARY KEY CLUSTERED ([cd_tipo_pag_comissao] ASC) WITH (FILLFACTOR = 90)
);

