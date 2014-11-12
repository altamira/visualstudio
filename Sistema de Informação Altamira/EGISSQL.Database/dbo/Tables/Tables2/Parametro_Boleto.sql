CREATE TABLE [dbo].[Parametro_Boleto] (
    [cd_empresa]           INT           NOT NULL,
    [pc_multa_boleto]      FLOAT (53)    NULL,
    [pc_juros_boleto]      FLOAT (53)    NULL,
    [ds_banco_boleto]      TEXT          NULL,
    [ic_form_banco_boleto] CHAR (1)      NULL,
    [nm_local_pagamento]   VARCHAR (150) NULL,
    [cd_conta_banco]       INT           NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    [cd_formulario]        INT           NULL,
    CONSTRAINT [PK_Parametro_Boleto] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Boleto_Conta_Agencia_Banco] FOREIGN KEY ([cd_conta_banco]) REFERENCES [dbo].[Conta_Agencia_Banco] ([cd_conta_banco]),
    CONSTRAINT [FK_Parametro_Boleto_Formulario] FOREIGN KEY ([cd_formulario]) REFERENCES [dbo].[Formulario] ([cd_formulario])
);

