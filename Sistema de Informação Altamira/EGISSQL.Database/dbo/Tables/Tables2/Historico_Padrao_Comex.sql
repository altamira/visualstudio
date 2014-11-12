CREATE TABLE [dbo].[Historico_Padrao_Comex] (
    [cd_historico_padrao_comex] INT          NOT NULL,
    [nm_historico_padrao_comex] VARCHAR (40) NOT NULL,
    [sg_historico_padrao_comex] CHAR (10)    NOT NULL,
    [ds_historico_padrao_comex] TEXT         NOT NULL,
    [cd_idioma]                 INT          NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Historico_Padrao_Comex] PRIMARY KEY CLUSTERED ([cd_historico_padrao_comex] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Historico_Padrao_Comex_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

