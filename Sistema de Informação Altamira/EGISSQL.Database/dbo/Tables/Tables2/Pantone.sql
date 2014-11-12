CREATE TABLE [dbo].[Pantone] (
    [cd_pantone]          INT          NOT NULL,
    [nm_pantone]          VARCHAR (40) NULL,
    [nm_fantasia_pantone] VARCHAR (15) NULL,
    [nm_cor_pantone]      VARCHAR (25) NULL,
    [ds_pantone]          TEXT         NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Pantone] PRIMARY KEY CLUSTERED ([cd_pantone] ASC) WITH (FILLFACTOR = 90)
);

