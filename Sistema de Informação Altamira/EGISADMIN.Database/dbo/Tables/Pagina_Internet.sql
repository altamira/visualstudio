CREATE TABLE [dbo].[Pagina_Internet] (
    [cd_pagina]          INT           NOT NULL,
    [nm_pagina]          VARCHAR (60)  NULL,
    [nm_caminho_pagina]  VARCHAR (100) NULL,
    [nm_endereco_pagina] VARCHAR (100) NULL,
    [cd_modulo]          INT           NULL,
    [ds_pagina]          TEXT          NULL,
    [nm_obs_pagina]      VARCHAR (40)  NULL,
    [cd_usuario]         INT           NULL,
    [dt_usuario]         DATETIME      NULL,
    CONSTRAINT [PK_Pagina_Internet] PRIMARY KEY CLUSTERED ([cd_pagina] ASC) WITH (FILLFACTOR = 90)
);

