CREATE TABLE [dbo].[Tipo_Pagto_Eletronico] (
    [cd_tipo_pagto_eletronico] INT          NOT NULL,
    [nm_tipo_pagto_eletronico] VARCHAR (40) NOT NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Pagto_Eletronico] PRIMARY KEY CLUSTERED ([cd_tipo_pagto_eletronico] ASC) WITH (FILLFACTOR = 90)
);

