CREATE TABLE [dbo].[Tipo_Pagto_Eletr_GPS] (
    [cd_tipo_pagto_gps] INT          NOT NULL,
    [nm_tipo_pagto_gps] VARCHAR (40) NOT NULL,
    [sg_tipo_pagto_gps] CHAR (4)     NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Pagto_Eletr_GPS] PRIMARY KEY CLUSTERED ([cd_tipo_pagto_gps] ASC) WITH (FILLFACTOR = 90)
);

