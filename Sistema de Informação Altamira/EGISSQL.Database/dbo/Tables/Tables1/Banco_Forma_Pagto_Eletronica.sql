CREATE TABLE [dbo].[Banco_Forma_Pagto_Eletronica] (
    [cd_banco]                  INT      NOT NULL,
    [cd_forma_pagto_eletronica] INT      NOT NULL,
    [sg_banco_forma_pagto]      CHAR (4) NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Banco_Forma_Pagto_Eletronica] PRIMARY KEY CLUSTERED ([cd_banco] ASC, [cd_forma_pagto_eletronica] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Banco_Forma_Pagto_Eletronica_Forma_Pagto_Eletronica] FOREIGN KEY ([cd_forma_pagto_eletronica]) REFERENCES [dbo].[Forma_Pagto_Eletronica] ([cd_forma_pagto_eletronica])
);

