CREATE TABLE [dbo].[Pagamento_Comissao] (
    [cd_pag_comissao] INT          NOT NULL,
    [nm_pag_comissao] VARCHAR (30) NOT NULL,
    [sg_pag_comissao] CHAR (10)    NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    CONSTRAINT [PK_Pagamento_Comissao] PRIMARY KEY CLUSTERED ([cd_pag_comissao] ASC) WITH (FILLFACTOR = 90)
);

