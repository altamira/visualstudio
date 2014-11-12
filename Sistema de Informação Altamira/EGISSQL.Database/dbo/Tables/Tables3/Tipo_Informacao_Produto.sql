CREATE TABLE [dbo].[Tipo_Informacao_Produto] (
    [cd_tp_informacao_produto] INT          NOT NULL,
    [nm_tp_informacao_produto] VARCHAR (70) NULL,
    [sg_tp_informacao_produto] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Informacao_Produto] PRIMARY KEY CLUSTERED ([cd_tp_informacao_produto] ASC) WITH (FILLFACTOR = 90)
);

