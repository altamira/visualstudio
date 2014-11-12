CREATE TABLE [dbo].[Condicao_Pagamento_Idioma] (
    [cd_condicao_pagamento]   INT          NOT NULL,
    [cd_idioma]               INT          NOT NULL,
    [nm_condicao_pgto_idioma] VARCHAR (30) NULL,
    [sg_condicao_pgto_idioma] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ds_condicao_pgto_idioma] TEXT         NULL,
    CONSTRAINT [PK_Condicao_Pagamento_Idioma] PRIMARY KEY CLUSTERED ([cd_condicao_pagamento] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Condicao_Pagamento_Idioma_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

