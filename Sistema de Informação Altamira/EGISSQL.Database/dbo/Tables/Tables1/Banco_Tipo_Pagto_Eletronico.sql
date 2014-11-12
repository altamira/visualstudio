CREATE TABLE [dbo].[Banco_Tipo_Pagto_Eletronico] (
    [cd_banco]                 INT      NOT NULL,
    [cd_tipo_pagto_eletronico] INT      NOT NULL,
    [sg_banco_tipo_pagto]      CHAR (4) NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Banco_Tipo_Pagto_Eletronico] PRIMARY KEY CLUSTERED ([cd_banco] ASC, [cd_tipo_pagto_eletronico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Banco_Tipo_Pagto_Eletronico_Tipo_Pagto_Eletronico] FOREIGN KEY ([cd_tipo_pagto_eletronico]) REFERENCES [dbo].[Tipo_Pagto_Eletronico] ([cd_tipo_pagto_eletronico])
);

