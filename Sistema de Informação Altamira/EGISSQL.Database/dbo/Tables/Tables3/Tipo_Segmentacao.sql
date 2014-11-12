CREATE TABLE [dbo].[Tipo_Segmentacao] (
    [cd_tipo_segmentacao] INT          NOT NULL,
    [nm_tipo_segmentacao] VARCHAR (30) NOT NULL,
    [sg_tipo_segmentacao] VARCHAR (10) NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Segmentacao] PRIMARY KEY CLUSTERED ([cd_tipo_segmentacao] ASC) WITH (FILLFACTOR = 90)
);

