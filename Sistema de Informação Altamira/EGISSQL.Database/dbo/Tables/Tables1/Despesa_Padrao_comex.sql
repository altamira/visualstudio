CREATE TABLE [dbo].[Despesa_Padrao_comex] (
    [cd_despesa_padrao_comex] INT          NOT NULL,
    [nm_despesa_padrao_comex] VARCHAR (30) NOT NULL,
    [sg_despesa_padrao_comex] CHAR (10)    NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [ds_outras_despesas]      TEXT         NULL,
    CONSTRAINT [PK_Despesa_Padrao_comex] PRIMARY KEY CLUSTERED ([cd_despesa_padrao_comex] ASC) WITH (FILLFACTOR = 90)
);

