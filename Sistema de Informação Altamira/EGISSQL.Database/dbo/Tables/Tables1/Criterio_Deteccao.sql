CREATE TABLE [dbo].[Criterio_Deteccao] (
    [cd_criterio_deteccao] INT          NOT NULL,
    [nm_criterio_deteccao] VARCHAR (40) NULL,
    [ds_criterio_deteccao] TEXT         NULL,
    [qt_criterio_deteccao] INT          NOT NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Criterio_Deteccao] PRIMARY KEY CLUSTERED ([cd_criterio_deteccao] ASC) WITH (FILLFACTOR = 90)
);

