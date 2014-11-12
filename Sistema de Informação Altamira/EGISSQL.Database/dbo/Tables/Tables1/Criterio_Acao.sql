CREATE TABLE [dbo].[Criterio_Acao] (
    [cd_criterio_acao] INT          NOT NULL,
    [nm_criterio_acao] VARCHAR (40) NULL,
    [sg_criterio_acao] CHAR (10)    NULL,
    [ds_criterio_acao] TEXT         NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Criterio_Acao] PRIMARY KEY CLUSTERED ([cd_criterio_acao] ASC) WITH (FILLFACTOR = 90)
);

