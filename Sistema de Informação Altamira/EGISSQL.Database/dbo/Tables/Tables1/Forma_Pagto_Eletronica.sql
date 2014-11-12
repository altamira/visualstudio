CREATE TABLE [dbo].[Forma_Pagto_Eletronica] (
    [cd_forma_pagto_eletronica] INT          NOT NULL,
    [nm_forma_pagto_eletronica] VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Forma_Pagto_Eletronica] PRIMARY KEY CLUSTERED ([cd_forma_pagto_eletronica] ASC) WITH (FILLFACTOR = 90)
);

