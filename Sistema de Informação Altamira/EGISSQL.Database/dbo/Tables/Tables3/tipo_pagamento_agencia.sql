CREATE TABLE [dbo].[tipo_pagamento_agencia] (
    [cd_tipo_pagto_agencia] INT          NOT NULL,
    [nm_tipo_pagto_agencia] VARCHAR (30) NOT NULL,
    [sg_tipo_pagto_agencia] CHAR (10)    NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_tipo_pagamento_agencia] PRIMARY KEY CLUSTERED ([cd_tipo_pagto_agencia] ASC) WITH (FILLFACTOR = 90)
);

