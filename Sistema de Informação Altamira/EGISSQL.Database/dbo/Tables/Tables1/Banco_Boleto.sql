CREATE TABLE [dbo].[Banco_Boleto] (
    [cd_banco]                INT           NOT NULL,
    [pc_multa_banco]          FLOAT (53)    NULL,
    [pc_juros_banco]          FLOAT (53)    NULL,
    [ds_banco_boleto]         TEXT          NULL,
    [nm_logo_banco_boleto]    VARCHAR (100) NULL,
    [ic_form_banco_boleto]    CHAR (1)      NULL,
    [nm_local_pagamento]      VARCHAR (150) NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_formulario]           INT           NULL,
    [ic_calculo_juros_boleto] CHAR (1)      NULL,
    [sg_especie_doc_boleto]   VARCHAR (10)  NULL,
    CONSTRAINT [PK_Banco_Boleto] PRIMARY KEY CLUSTERED ([cd_banco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Banco_Boleto_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco]),
    CONSTRAINT [FK_Banco_Boleto_Formulario] FOREIGN KEY ([cd_formulario]) REFERENCES [dbo].[Formulario] ([cd_formulario])
);

