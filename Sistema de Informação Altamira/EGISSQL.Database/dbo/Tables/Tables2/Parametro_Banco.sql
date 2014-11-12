CREATE TABLE [dbo].[Parametro_Banco] (
    [cd_empresa]           INT           NULL,
    [pc_multa_boleto]      FLOAT (53)    NULL,
    [pc_juros_boleto]      FLOAT (53)    NULL,
    [ds_banco_boleto]      TEXT          NULL,
    [ic_form_banco_boleto] CHAR (1)      NULL,
    [nm_local_pagamento]   VARCHAR (150) NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    CONSTRAINT [FK_Parametro_Banco_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

