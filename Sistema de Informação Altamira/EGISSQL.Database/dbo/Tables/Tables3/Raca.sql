CREATE TABLE [dbo].[Raca] (
    [cd_raca]         INT           NOT NULL,
    [nm_raca]         VARCHAR (60)  NULL,
    [ds_raca]         TEXT          NULL,
    [nm_foto_raca]    VARCHAR (150) NULL,
    [nm_desenho_raca] VARCHAR (150) NULL,
    [cd_usuario]      INT           NULL,
    [dt_usuario]      DATETIME      NULL,
    CONSTRAINT [PK_Raca] PRIMARY KEY CLUSTERED ([cd_raca] ASC)
);

