CREATE TABLE [dbo].[Sucata] (
    [cd_sucata]          INT          NOT NULL,
    [nm_sucata]          VARCHAR (50) NULL,
    [nm_fantasia_sucata] VARCHAR (15) NULL,
    [ds_sucata]          TEXT         NULL,
    [vl_sucata]          FLOAT (53)   NULL,
    [cd_mat_prima]       INT          NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [nm_obs_sucata]      VARCHAR (40) NULL,
    CONSTRAINT [PK_Sucata] PRIMARY KEY CLUSTERED ([cd_sucata] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Sucata_Materia_Prima] FOREIGN KEY ([cd_mat_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima])
);

