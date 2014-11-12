CREATE TABLE [dbo].[Criterio_Severidade] (
    [cd_criterio_severidade] INT          NOT NULL,
    [nm_criterio_severidade] VARCHAR (50) NULL,
    [ds_criterio_severidade] TEXT         NULL,
    [qt_criterio_severidade] INT          NOT NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Criterio_Severidade] PRIMARY KEY CLUSTERED ([cd_criterio_severidade] ASC) WITH (FILLFACTOR = 90)
);

