CREATE TABLE [dbo].[Modalidade_Pagamento_Idioma] (
    [cd_modalidade_pagamento] INT          NOT NULL,
    [cd_idioma]               INT          NOT NULL,
    [nm_modalidade_idioma]    VARCHAR (40) NULL,
    [ds_modalidade_idioma]    TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Modalidade_Pagamento_Idioma] PRIMARY KEY CLUSTERED ([cd_modalidade_pagamento] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modalidade_Pagamento_Idioma_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

