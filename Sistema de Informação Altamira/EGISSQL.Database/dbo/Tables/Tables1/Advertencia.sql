CREATE TABLE [dbo].[Advertencia] (
    [cd_advertencia] INT          NOT NULL,
    [nm_advertencia] VARCHAR (40) NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    [ds_advertencia] TEXT         NULL,
    CONSTRAINT [PK_Advertencia] PRIMARY KEY CLUSTERED ([cd_advertencia] ASC) WITH (FILLFACTOR = 90)
);

