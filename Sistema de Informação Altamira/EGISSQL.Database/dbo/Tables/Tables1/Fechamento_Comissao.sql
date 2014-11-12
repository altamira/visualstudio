CREATE TABLE [dbo].[Fechamento_Comissao] (
    [cd_comissao]         INT      NOT NULL,
    [dt_calculo_comissao] DATETIME NULL,
    [dt_base_comissao]    DATETIME NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    [ic_fechada_comissao] CHAR (1) NULL,
    CONSTRAINT [PK_Fechamento_Comissao] PRIMARY KEY CLUSTERED ([cd_comissao] ASC) WITH (FILLFACTOR = 90)
);

