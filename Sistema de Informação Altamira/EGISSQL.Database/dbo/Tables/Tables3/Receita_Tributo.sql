CREATE TABLE [dbo].[Receita_Tributo] (
    [cd_receita_tributo]          INT           NOT NULL,
    [sg_receita_tributo]          VARCHAR (7)   NOT NULL,
    [nm_receita_tributo]          VARCHAR (120) NULL,
    [cd_imposto]                  INT           NULL,
    [ic_tipo_pagamento_receita]   CHAR (1)      NULL,
    [dt_validade_receita_tributo] DATETIME      NULL,
    [cd_usuario]                  INT           NULL,
    [dt_usuario]                  DATETIME      NULL,
    CONSTRAINT [PK_Receita_Tributo] PRIMARY KEY CLUSTERED ([cd_receita_tributo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Receita_Tributo_Imposto] FOREIGN KEY ([cd_imposto]) REFERENCES [dbo].[Imposto] ([cd_imposto])
);

